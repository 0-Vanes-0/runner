class_name StateMachine
extends Node
# Generic state machine. Initializes states and delegates engine callbacks (_physics_process, _unhandled_input) to the active state.
# Nathan Lovato Copyright

# Emitted when transitioning to a new state.
signal transitioned(state_name: StringName)
# Path to the initial active state. We export it to be able to pick the initial state in the inspector.
@export var initial_state: State
# The current active state. At the start of the game, we get the `initial_state`.
@onready var state: State = get_node(initial_state.get_path())
#const HISTORY_SIZE := 5
#var state_history: Array[State] = []


func _ready() -> void:
	assert(owner != null)
	await owner.ready
	for child in (get_children() as Array[State]):
		child.state_machine = self
	state.enter()
#	_add_to_history(state)


func _unhandled_input(event: InputEvent) -> void:
	state.handle_input(event)


func _process(delta: float) -> void:
	state.update(delta)


func _physics_process(delta: float) -> void:
	state.physics_update(delta)


func transition_to(target_state: State, is_transition_forced: bool = false):
	var can_transition: bool = (
			is_transition_forced
			or
			self.has_node(target_state.get_path())
			and state.connections.has(target_state)
			and target_state.can_go_to_state()
	)
	if can_transition:
		state.exit()
		state = target_state
		state.enter()
		transitioned.emit(state.name)
#		_add_to_history(state)


#func get_prevoius_state(state: State) -> State:
#	var i := state_history.find(state)
#	if i != -1 and i+1 < HISTORY_SIZE and state_history[i+1] != null:
#		return state_history[i+1]
#	return null


#func _add_to_history(state: State):
#	if state_history.size() == HISTORY_SIZE:
#		state_history.pop_back()
#	state_history.push_front(state)


func _print_transition_conditions(target_state: State):
	print_debug(
		"StateMachine has target state: ", self.has_node(target_state.get_path()), "\n",
		"Current state has target state in connections: ", state.connections.has(target_state), "\n",
		"Is target state available: ", target_state.can_go_to_state()
	)
