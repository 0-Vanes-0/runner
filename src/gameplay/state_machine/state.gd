class_name State
extends Node
# Virtual base class for all states.
# Nathan Lovato Copyright

@export var connections: Array[State] #!!!!!!!!!!!!!!!!!!!!


var state_machine: StateMachine = null


# For creating states in code, not in editor
func _init() -> void:
	pass


func can_go_to_state() -> bool:
	return true


# Virtual function. Receives events from the `_unhandled_input()` callback.
func handle_input(event: InputEvent):
	pass


# Virtual function. Corresponds to the `_process()` callback.
func update(delta: float):
	pass


# Virtual function. Corresponds to the `_physics_process()` callback.
func physics_update(delta: float):
	pass


# Virtual function. Called by the state machine upon changing the active state. The `msg` parameter is a dictionary with arbitrary data the state can use to initialize itself.
func enter():
	pass


# Virtual function. Called by the state machine before changing the active state. Use this function to clean up the state.
func exit():
	pass
