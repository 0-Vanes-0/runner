class_name State
extends Node
# Virtual base class for all states.
# Nathan Lovato Copyright

@export var connections_paths: Array[NodePath]
var connections: Array[State]


var state_machine: StateMachine = null


# For creating states in code, not in editor
func _init() -> void:
	connections_paths.resize(1)


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
	assert(not connections_paths.is_empty() or not connections.is_empty(), "No connections for State!")
	if connections_paths.size() == 1 and connections_paths[0].is_empty():
		connections.resize(1)
	else:
		connections.assign(connections_paths.map(get_node))
	assert(not connections.is_empty(), "Bad convertion for connections array!")


# Virtual function. Called by the state machine before changing the active state. Use this function to clean up the state.
func exit():
	pass
