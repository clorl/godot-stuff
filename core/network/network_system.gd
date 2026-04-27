extends Node

const MAX_CONNECT_RETRIES = 10

func _ready():
	LimboConsole.register_command(client_start, "connect", "Connect to a game server")
	multiplayer.peer_connected.connect(func(id): print("Peer connected %d" %id))
	multiplayer.peer_disconnected.connect(func(id): print("Peer disconnected %d" %id))
	multiplayer.connected_to_server.connect(func(): print("[CLIENT] Connected to server"))
	multiplayer.server_disconnected.connect(func(): print("[CLIENT] Server disconnected"))

	if "-connect" in OS.get_cmdline_args():
		client_start()
	else:
		server_start()

func server_start(port := 6413):
	stop()
	var peer = ENetMultiplayerPeer.new()
	Engine.print_error_messages = false
	var err = peer.create_server(port)
	Engine.print_error_messages = true
	if err != OK:
		var errs = error_string(err)
		print("ERROR: (%s): Failed to start server." % error_string(err))
		if err == ERR_CANT_CREATE:
			print("HINT: Port %d is probably already in use - either by another program or by another instance of the game." % port)
		peer.close()
		return
	multiplayer.multiplayer_peer = peer
	Debug.set_text("network", "Server")
	print("Server listening on %d" % port)

	# Simulate lag
	if "-simulate-lag" in OS.get_cmdline_args():
		peer.host.bandwidth_limit(1,1)

func stop():
	multiplayer.multiplayer_peer.close()
	multiplayer.multiplayer_peer = OfflineMultiplayerPeer.new()
	Debug.set_text("network", "")

func client_start(addr := "127.0.0.1", port := 6413, retry_delay := -1, retry_count := 0):
	stop()
	var peer = ENetMultiplayerPeer.new()
	var err = peer.create_client(addr, port)
	if err != OK:
		print("Failed to start client: %s", error_string(err))
		peer.close()
		return
	multiplayer.multiplayer_peer = peer
	Debug.set_text("network", "Client")
	print("[CLIENT] Connecting to %s:%d" % [addr, port])
	multiplayer.connection_failed.connect(func(): _on_connection_failed(addr, port, retry_delay, retry_count), ConnectFlags.CONNECT_ONE_SHOT)

	if "-simulate-lag" in OS.get_cmdline_args():
		peer.host.bandwidth_limit(1,1)

func _on_connection_failed(addr, port, retry_delay, retry_count):
	print("[CLIENT] Failed to connect")
	if retry_delay < 0:
		return
	if retry_count >= MAX_CONNECT_RETRIES:
		print("Tried to reconnect %d times, we stop trying" % retry_count)
		return
	print("[CLIENT] Retrying in %d seconds" % retry_delay)
	if retry_delay > 0:
		await get_tree().create_timer(retry_delay).timeout
	client_start(addr, port, retry_delay, retry_count + 1)
