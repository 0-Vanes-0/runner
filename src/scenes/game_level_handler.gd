extends Node2D

var segments_length_x: float
var is_level_complete: bool
@onready var player: Player = $Player 
@onready var segments: Node2D = $Segments
@onready var bounds: StaticBody2D = $Bounds


func _ready():
	var height := Global.screen_height
	Preloader.segments.shuffle()
	for value in Preloader.segments:
		var segment: Segment = value.clone()
		segment.position.x = segments_length_x
		segments_length_x += segment.get_width()
		segments.add_child(segment, true)
	
	player.position = Vector2(100, height / 2)
	player.run_speed = Global.screen_width / 2
	var jump_height: float = (height - Platform.SIZE.y) / Global.MAX_FLOORS + Platform.SIZE.y
	player.jump_speed = sqrt(2 * player.gravity * jump_height)
	player.dodge_time = 1.0
	
	($Bounds/Top.shape as SegmentShape2D).a = Vector2(0, 0)
	($Bounds/Top.shape as SegmentShape2D).b = Vector2(Global.screen_width, 0)
	($Bounds/Right.shape as SegmentShape2D).a = Vector2(Global.screen_width, 0)
	($Bounds/Right.shape as SegmentShape2D).b = Vector2(Global.screen_width, Global.screen_height)
	($Bounds/Bottom.shape as SegmentShape2D).a = Vector2(Global.screen_width, Global.screen_height)
	($Bounds/Bottom.shape as SegmentShape2D).b = Vector2(0, Global.screen_height)
	($Bounds/Left.shape as SegmentShape2D).a = Vector2(0, Global.screen_height)
	($Bounds/Left.shape as SegmentShape2D).b = Vector2(0, 0)
	Global.clean_layers($Bounds).set_collision_layer_value(Global.Layers.BOUNDS, true)


func _physics_process(delta):
	if segments_length_x > Global.screen_width:
		for child in segments.get_children():
			if child is Segment:
				child.position.x -= delta * player.run_speed
				if child.position.x + child.get_width() < 0:
					child.queue_free()
		segments_length_x -= delta * player.run_speed
	elif not is_level_complete:
		is_level_complete = true
		_on_level_complete()
		

func _on_level_complete():
	(get_tree().current_scene.get_node("HUD/Button") as Button).visible = true
	player.state_machine.transition_to(player.state_dead)


func _on_reset_pressed():
	get_tree().reload_current_scene()
