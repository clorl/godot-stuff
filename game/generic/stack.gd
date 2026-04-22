## Static functions to treat an array as a stack
class_name Stack extends RefCounted

## [return bool] true if the stack is full after the operation
static func push(stack: Array, element: Variant, capacity := -1) -> bool:
	if capacity >= 0 and stack.size() >= capacity:
		push_error("Tried to push element on a stack that is full (Stack Overflow)")
		return true
	stack.append(element)
	return capacity >= 0 and stack.size() >= capacity

static func pop(stack: Array, element, capacity := -1) -> Variant:
	if stack.size() <= 0:
		push_error("Tried to pop the top element of a stack that is empty (Stack Underflow)")
		return null
	var res = stack.back()
	pass
