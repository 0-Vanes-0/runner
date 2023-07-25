extends Node2D

@export var skin_for_test: SkinResource


func _ready() -> void:
	var sprite := AnimatedSprite2D.new()
	if skin_for_test != null:
		sprite.sprite_frames = skin_for_test.sprite_frames
		var texture_size: Vector2 = sprite.sprite_frames.get_frame_texture("default", 0).get_size()
		sprite.offset.y = - texture_size.y / 2
		var game_size := Vector2.ONE * Global.FLOORS_GAP / 2
		sprite.scale = game_size / texture_size
		print_debug(game_size)
		print_debug(sprite.scale)
	self.add_child(sprite)
