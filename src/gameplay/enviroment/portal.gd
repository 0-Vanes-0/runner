class_name Portal
extends Area2D

signal portal_chosen(reward: Reward)

var reward: Reward
var sprite: AnimatedSprite2D
var collision_shape: CollisionShape2D


func _init(reward: Reward) -> void:
	self.reward = reward
	
	sprite = AnimatedSprite2D.new()
	sprite.sprite_frames = SpriteFrames.new()
	sprite.sprite_frames.add_frame("default", preload("res://assets/sprites/BG 4.png")) 			# Remove later
	sprite.modulate = Reward.PORTAL_COLORS[reward.get_type()]
	self.add_child(sprite)
	sprite.scale = Global.player.get_game_size() * 2 / sprite.sprite_frames.get_frame_texture("default", 0).get_size()
	
	collision_shape = CollisionShape2D.new()
	collision_shape.shape = RectangleShape2D.new()
	collision_shape.shape.size = Global.player.get_game_size()
	self.add_child(collision_shape)
	
	var label := Global.create_ui_label()
	if reward.get_type() == Reward.DEMON_PASSIVITY:
		var res := reward.get_as_demon_passivity_res()
		label.text = res.Types.keys()[ res.Types.values().find(res.type) ] + " +" + str(res.value) + "%"
	label.set_anchors_and_offsets_preset(Control.PRESET_CENTER)
	self.add_child(label)
	
	Global.clean_layers(self).set_collision_layer_value(Global.Layers.BOUNDS, true)
	self.input_event.connect(_on_input_event)


func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int):
	if event is InputEventScreenTouch and event.pressed:
		portal_chosen.emit(reward)


#func _ready() -> void:
#	var duration: float = sprite.sprite_frames.get_animation_speed("open") * sprite.sprite_frames.get_frame_count("open")
#	sprite.play("open")
#	await get_tree().create_timer(duration).timeout
#	sprite.play("default")
