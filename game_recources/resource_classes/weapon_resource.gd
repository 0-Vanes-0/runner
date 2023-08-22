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
@export_multiline var description: String = "" ## Description of weapon.

@export_group("Resources")
@export var shoot_entity_resource: ShootEntityResource ## Resources of what weapon will shoot.
@export var status_resource: StatusResource

@export_group("Weapon stats")
## Damage dealing by [Player].
@export var damage_from_player := {
	Rarity.NAMES[Rarity.NORMAL]: 0,
	Rarity.NAMES[Rarity.RARE]: 0,
	Rarity.NAMES[Rarity.EPIC]: 0,
	Rarity.NAMES[Rarity.LEGENDARY]: 0,
}
## Damage dealing by [Enemy].
@export_range(1, 1000, 1) var damage_from_enemy: int = 10
## Max amount of [member ammo].
@export var ammo_max := {
	Rarity.NAMES[Rarity.NORMAL]: 1,
	Rarity.NAMES[Rarity.RARE]: 1,
	Rarity.NAMES[Rarity.EPIC]: 1,
	Rarity.NAMES[Rarity.LEGENDARY]: 1,
}
@export_range(1, 100) var ammo_snap_step: int = 1
## Time in seconds for [method Weapon.reload].
@export var reload_time := {
	Rarity.NAMES[Rarity.NORMAL]: 0.0,
	Rarity.NAMES[Rarity.RARE]: 0.0,
	Rarity.NAMES[Rarity.EPIC]: 0.0,
	Rarity.NAMES[Rarity.LEGENDARY]: 0.0,
}
## Time in seconds for pauses between shooting.
@export var shoot_rate_time := {
	Rarity.NAMES[Rarity.NORMAL]: 1.0,
	Rarity.NAMES[Rarity.RARE]: 1.0,
	Rarity.NAMES[Rarity.EPIC]: 1.0,
	Rarity.NAMES[Rarity.LEGENDARY]: 1.0,
}
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


func get_description(rarity: Rarity) -> String:
	var damage := get_damage(rarity)
	var ammo_max := get_ammo_max(rarity)
	var reload_time := get_reload_time(rarity)
	var shoot_rate_time := get_shoot_rate_time(rarity)
	
	var text := "Shoots $1\nDPS = $2\nAmmo = $3\n" + description
	text = text.replace(
			"$1", 
			ShootEntityResource.EntityClasses.keys()[shoot_entity_resource.entity_class]
	)
	text = text.replace(
			"$2", 
			str(damage / shoot_rate_time).pad_decimals(2) 
			+ " (" 
			+ str(damage * ammo_max / (shoot_rate_time * ammo_max + reload_time)).pad_decimals(2) 
			+ " with reload)"
	)
	text = text.replace(
			"$3", 
			str(ammo_max if ammo_max > 1 else "endless")
	)
	return text


func get_damage(rarity: Rarity) -> int:
	return damage_from_player[rarity.get_name()]


func get_ammo_max(rarity: Rarity) -> int:
	return ammo_max[rarity.get_name()]


func get_reload_time(rarity: Rarity) -> float:
	return reload_time[rarity.get_name()]


func get_shoot_rate_time(rarity: Rarity) -> float:
	return shoot_rate_time[rarity.get_name()]
