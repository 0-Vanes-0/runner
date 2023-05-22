class_name ShootEntityResource
extends Resource

enum EntityClasses {
	NONE,
	PROJECTILE_LINEAR,
	PROJECTILE_RICO,
}
@export var entity_class: EntityClasses = EntityClasses.NONE
@export_range(1, 1000, 1) var damage: int = 10
@export var sprite_frames: SpriteFrames


func get_sprite_size() -> Vector2:
	if sprite_frames != null and sprite_frames.has_animation("default"):
		var texture := sprite_frames.get_frame_texture("default", 0)
		if texture != null:
			return texture.get_size()
		else: 
			print_debug("texture of 'default' is null")
	print_debug("sprite_frames is null or have not animation 'default'!")
	return Vector2.ZERO
