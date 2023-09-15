class_name RewardResource
extends Resource

@export var demon_passivities: Array[DemonPassivityResource]
@export var weapon_passivities: Array[WeaponPassivityResource]
@export var statuses: Array[StatusResource]
@export var weapons: Array[WeaponResource]
@export var activities: Array[ActivityResource]


func get_demon_passivity() -> DemonPassivityResource:
	return demon_passivities.pick_random() as DemonPassivityResource


func get_weapon_passivity() -> WeaponPassivityResource:
	return weapon_passivities.pick_random() as WeaponPassivityResource


func get_status() -> StatusResource:
	return statuses.pick_random() as StatusResource


func get_weapon() -> WeaponResource:
	return weapons.pick_random() as WeaponResource


func get_activity() -> ActivityResource:
	return activities.pick_random() as ActivityResource
