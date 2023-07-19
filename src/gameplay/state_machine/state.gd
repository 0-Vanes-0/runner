## Virtual base class for all states.
## [br]Nathan Lovato Copyright
class_name State
extends Node

## Array of connected states. It represents one way arrow.
@export var connections: Array[State]
## Reference to state machine which owns all states. It is initialized during [code]_ready()[/code] of [StateMachine].
var state_machine: StateMachine = null


# For creating states in code, not in editor.
func _init() -> void:
	pass

## Virtual function. This is called when [method StateMachine.transition_to] happens.
func can_go_to_state() -> bool:
	return true

## Virtual function. Receives events from the [code]_unhandled_input()[/code] callback.
func handle_input(event: InputEvent):
	pass

## Virtual function. Corresponds to the [code]_process()[/code] callback.
func update(delta: float):
	pass

## Virtual function. Corresponds to the [code]_physics_process()[/code] callback.
func physics_update(delta: float):
	pass

## Virtual function. Called by the state machine upon changing the active state.
func enter():
	pass

## Virtual function. Called by the state machine before changing the active state. Use this function to clean up the state.
func exit():
	pass
