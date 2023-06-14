class_name Portal
extends Area2D

signal portal_chosen																				#portal_chosen(destination: Biome)

#var destination: Biome
var sprite: AnimatedSprite2D
var collision_shape: CollisionShape2D


func _init(size: Vector2, modulate: Color) -> void: 												#func _init(size: Vector2) -> void:
	sprite = AnimatedSprite2D.new()
	sprite.sprite_frames = SpriteFrames.new()
	sprite.sprite_frames.add_frame("default", preload("res://assets/sprites/BG 4.png")) 			# Remove later
	
#	sprite.modulate = destination.portal_color
	sprite.modulate = modulate 																		# Remove later
	self.add_child(sprite)
	sprite.scale = size / sprite.sprite_frames.get_frame_texture("default", 0).get_size()
	
	collision_shape = CollisionShape2D.new()
	collision_shape.shape = RectangleShape2D.new()
	collision_shape.shape.size = size
	self.add_child(collision_shape)
	
	Global.clean_layers(self).set_collision_layer_value(Global.Layers.BOUNDS, true)
	self.input_event.connect(
		func(viewport: Node, event: InputEvent, shape_idx: int):
			if event is InputEventScreenTouch and event.pressed:
				portal_chosen.emit()
	)


#func _ready() -> void:
#	var duration: float = sprite.sprite_frames.get_animation_speed("open") * sprite.sprite_frames.get_frame_count("open")
#	sprite.play("open")
#	await get_tree().create_timer(duration).timeout
#	sprite.play("default")
