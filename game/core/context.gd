## Short for Context
## Globally accessible object that holds all general purpose utilities that we may want to override
## e.g. logging, assertion etc
## Probably should use Autoload for most things tho
## Users can add arbitrary data to it (how? TODO)
class_name Ctx
extends RefCounted

###### STATIC ######

## For advanced use cases you might want to manipulate the context stack manually. Do it if you really know what you're doing
## Never read the current context from here, use [code]Ctx.cur[/code]
static var stack: Array = []

## Getter for the current valid context (initializes if none exist
static var cur: Ctx: ## Shorthand for current
	get:
		if stack.size() <= 0:
			stack.append(Ctx.default())
		return stack.back()
	set(v): stack.append(v)


static func default() -> Ctx:
	return Ctx.new()

## Pushes a new context, runs the given [param code_to_run] with that context and restores the previous context
## returns whatever [param code_to_run] returns
static func push(new_ctx: Ctx, code_to_run: Callable) -> Variant:
	stack.push_back(new_ctx)
	var res = code_to_run.call()
	stack.pop_back()
	return res




###### INSTANCE ######

func _init():
	pass
