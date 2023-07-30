## This resource stores all info for [Weapon].
class_name WeaponResource
extends Resource

## This is string enum (type is Dictionary) storing names of animations.
const Animations := {
	default = "default",
	reload = "reload",
}

@export_group("Info")
@export var name: String = "Weapon" ## Name of weapon.
@export_multiline var description: String = "Shoots $1\nDPS = $2\nAmmo = $3" ## Description of weapon.
@export_group("Resources")
@export var shoot_entity_resource: ShootEntityResource ## Resources of what weapon will shoot.
@export var status_resource: StatusResource
@export_group("Weapon stats")
@export_range(1, 1000, 1) var damage_from_player: int = 10 ## Damage dealing by [Player].
@export_range(1, 1000, 1) var damage_from_enemy: int = 10 ## Damage dealing by [Enemy].
@export_range(1, 1000, 1) var ammo_max: int = 1 ## Max amount of [member ammo].
@export_range(0.0, 5.0, 0.1) var reload_time: float = 0.0 ## Time in seconds for [method Weapon.reload].
@export_range(0.1, 5.0, 0.1) var shoot_rate_time: float = 1.0 ## Time in seconds for pauses between shooting.
@export_range(0, 45, 1, "degrees") var spread_angle: int = 0 ## Degrees of spread which is a cone with hypotenuse directing to shoot position.
@export_group("Visuals")
@export var sprite_frames: SpriteFrames ## Animations of weapon.
@export_range(1, 10) var sprite_scale_value: int = 1 ## Scale of sprites (WIP).

## Returns size of texture of default animation.
func get_sprite_size() -> Vector2:
	if sprite_frames != null and sprite_frames.has_animation("default"):
		var texture := sprite_frames.get_frame_texture("default", 0)
		if texture != null:
			return texture.get_size()
		else: 
			print_debug("texture of 'default' is null")
	return Vector2.ZERO


func get_description() -> String:
	description = description.replace(
			"$1", 
			ShootEntityResource.EntityClasses.keys()[shoot_entity_resource.entity_class]
	)
	description = description.replace(
		"$2", 
		str(damage_from_player / shoot_rate_time).pad_decimals(2) 
		+ "\n(" + str(damage_from_player * ammo_max / (shoot_rate_time * ammo_max + reload_time)).pad_decimals(2) + " with reload)"
	)
	description = description.replace(
		"$3", 
		str(ammo_max if ammo_max > 1 else "endless")
	)
	return description
