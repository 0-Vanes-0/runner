class_name ShootEntityResource
extends Resource

enum EntityClasses {
	NONE,
	PROJECTILE_LINEAR,
	PROJECTILE_RICO,
	HITSCAN,
	LASER,
}
@export var entity_class: EntityClasses = EntityClasses.NONE
@export var sprite_frames: SpriteFrames
#@export var shoot_sound: AudioStreamWAV
var exist_from_start: bool = false


func get_sprite_size() -> Vector2:
	if sprite_frames != null and sprite_frames.has_animation("default"):
		var texture := sprite_frames.get_frame_texture("default", 0)
		assert(texture != null, "texture of 'default' is null")
		return texture.get_size()
	return Vector2.ZERO
