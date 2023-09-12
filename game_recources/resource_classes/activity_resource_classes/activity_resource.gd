class_name ActivityResource
extends Resource

@export var value_normal: int = 0
@export var value_rare: int = 0
@export var value_epic: int = 0
@export var value_legendary: int = 0
@export_range(0.0, 30.0, 0.1) var reload_time: float = 10.0
@export_range(0.0, 30.0, 0.1) var duration_time: float = 0.0


func action(): # virtual
	assert(false)


func action_end(): # virtual
	assert(false)
