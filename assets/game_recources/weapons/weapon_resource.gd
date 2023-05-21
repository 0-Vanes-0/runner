class_name WeaponResource
extends Resource

const Animations := {
	default = "default",
	reload = "reload",
}

@export var sprite_frames: SpriteFrames
@export_range(1, 10) var scale_value: int = 1
@export var shoot_entity_resource: Resource
@export_range(0.1, 5.0, 0.1) var shoot_rate_time: float = 1.0
@export_range(0, 45, 1, "degrees") var spread_angle: int = 0


func get_sprite_size() -> Vector2:
	if sprite_frames != null and sprite_frames.has_animation("default"):
		var texture := sprite_frames.get_frame_texture("default", 0)
		if texture != null:
			return texture.get_size()
		else: 
			print_debug("texture of 'default' is null")
	print_debug("sprite_frames is null or have not animation 'default'!")
	return Vector2.ZERO
