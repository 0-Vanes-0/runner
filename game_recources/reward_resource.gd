class_name RewardResource
extends Resource

@export_group("Demon Passivity", "demon_passivity_")
@export var demon_passivity_normal: Array[DemonPassivityResource]
@export var demon_passivity_rare: Array[DemonPassivityResource]
@export var demon_passivity_epic: Array[DemonPassivityResource]
@export var demon_passivity_legendary: Array[DemonPassivityResource]

@export_group("Weapon Passivity", "weapon_passivity_")
@export var weapon_passivity_normal: Array[WeaponPassivityResource]
@export var weapon_passivity_rare: Array[WeaponPassivityResource]
@export var weapon_passivity_epic: Array[WeaponPassivityResource]
@export var weapon_passivity_legendary: Array[WeaponPassivityResource]

@export_group("Status", "status_")
@export var status_normal: Array[StatusResource]
@export var status_rare: Array[StatusResource]
@export var status_epic: Array[StatusResource]
@export var status_legendary: Array[StatusResource]

@export_group("Weapon")
@export var weapon: Array[WeaponResource]

@export_group("Activity", "activity_")
@export var activity_normal: Array[ActivityResource]
@export var activity_rare: Array[ActivityResource]
@export var activity_epic: Array[ActivityResource]
@export var activity_legendary: Array[ActivityResource]


func get_demon_passivity(rarity: Rarity) -> DemonPassivityResource:
	match rarity.get_type():
		Rarity.NORMAL:
			return demon_passivity_normal.pick_random()
		Rarity.RARE:
			return demon_passivity_rare.pick_random()
		Rarity.EPIC:
			return demon_passivity_epic.pick_random()
		Rarity.LEGENDARY:
			return demon_passivity_legendary.pick_random()
		_:
			print_debug("Wrong rarity type: ", rarity.get_type())
			return null


func get_weapon_passivity(rarity: Rarity) -> WeaponPassivityResource:
	match rarity.get_type():
		Rarity.NORMAL:
			return weapon_passivity_normal.pick_random()
		Rarity.RARE:
			return weapon_passivity_rare.pick_random()
		Rarity.EPIC:
			return weapon_passivity_epic.pick_random()
		Rarity.LEGENDARY:
			return weapon_passivity_legendary.pick_random()
		_:
			print_debug("Wrong rarity type: ", rarity.get_type())
			return null


func get_status(rarity: Rarity) -> StatusResource:
	match rarity.get_type():
		Rarity.NORMAL:
			return status_normal.pick_random()
		Rarity.RARE:
			return status_rare.pick_random()
		Rarity.EPIC:
			return status_epic.pick_random()
		Rarity.LEGENDARY:
			return status_legendary.pick_random()
		_:
			print_debug("Wrong rarity type: ", rarity.get_type())
			return null


func get_weapon() -> WeaponResource:
	return weapon.pick_random() as WeaponResource


func get_activity(rarity: Rarity) -> ActivityResource:
	match rarity.get_type():
		Rarity.NORMAL:
			return activity_normal.pick_random()
		Rarity.RARE:
			return activity_rare.pick_random()
		Rarity.EPIC:
			return activity_epic.pick_random()
		Rarity.LEGENDARY:
			return activity_legendary.pick_random()
		_:
			print_debug("Wrong rarity type: ", rarity.get_type())
			return null
