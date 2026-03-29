GODOT = godot --no-header --headless
GUT = $(GODOT) --path ./game -s res://addons/gut/gut_cmdln.gd -gcompact_mode

default:
	@echo "Help message todo"

test:
	$(GUT) -gdir=res://test -ginclude_subdirs -gexit

