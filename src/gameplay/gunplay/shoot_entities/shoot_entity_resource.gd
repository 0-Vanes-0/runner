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
@export var shoot_field_path: NodePath


func get_sprite_size() -> Vector2:
	if sprite_frames != null and sprite_frames.has_animation("default"):
		var texture := sprite_frames.get_frame_texture("default", 0)
		assert(texture != null, "texture of 'default' is null")
		return texture.get_size()
	return Vector2.ZERO
