class_name Reward
extends Object

const DEMON_PASSIVITY: int = 1
const WEAPON_PASSIVITY: int = 2
const SHOOT_ENTITY_STATUS: int = 3
const WEAPON: int = 4
const ACTIVITY: int = 5

const DEMON_PASSIVITY_CHANCE: int = 40
const WEAPON_PASSIVITY_CHANCE: int = 20
const SHOOT_ENTITY_STATUS_CHANCE: int = 20
const WEAPON_CHANCE: int = 10
const ACTIVITY_CHANCE: int = 10
static var CHANCES_SUM: int = DEMON_PASSIVITY_CHANCE + WEAPON_PASSIVITY_CHANCE + SHOOT_ENTITY_STATUS_CHANCE + WEAPON_CHANCE + ACTIVITY_CHANCE

var _type: int = 0
var _value: Resource
var _rarity: Rarity


func _init(type: int, rarity: Rarity) -> void:
	_type = type
	var reward_res := Preloader.reward_resource as RewardResource
	match type:
		DEMON_PASSIVITY:
			_value = reward_res.get_demon_passivity()
		WEAPON_PASSIVITY:
			_value = reward_res.get_weapon_passivity()
		SHOOT_ENTITY_STATUS:
			_value = reward_res.get_status()
		WEAPON:
			_value = reward_res.get_weapon()
		ACTIVITY:
			_value = reward_res.get_activity()
		_:
			assert(false, "WRONG TYPE OF REWARD: " + str(type))
	_rarity = rarity


func get_type() -> int:
	return _type


func get_as_resource() -> Resource:
	return _value


func get_as_demon_passivity_res() -> DemonPassivityResource:
	return _value as DemonPassivityResource


func get_as_weapon_passivity_res() -> WeaponPassivityResource:
	return _value as WeaponPassivityResource


func get_as_status_res() -> StatusResource:
	return _value as StatusResource


func get_as_weapon_res() -> WeaponResource:
	return _value as WeaponResource


func get_rarity() -> Rarity:
	return _rarity


func get_as_activity_res() -> ActivityResource:
	return _value as ActivityResource


static func generate_reward(reward_type: int = 0) -> Reward:
	var random_type := randi_range(1, CHANCES_SUM)
	if reward_type == DEMON_PASSIVITY or reward_type == 0 and random_type <= DEMON_PASSIVITY_CHANCE:
		return Reward.new(DEMON_PASSIVITY, Rarity.generate_rarity())
	elif reward_type == WEAPON_PASSIVITY or reward_type == 0 and random_type <= DEMON_PASSIVITY_CHANCE + WEAPON_PASSIVITY_CHANCE:
		return Reward.new(WEAPON_PASSIVITY, Rarity.generate_rarity())
	elif reward_type == SHOOT_ENTITY_STATUS or reward_type == 0 and random_type <= DEMON_PASSIVITY_CHANCE + WEAPON_PASSIVITY_CHANCE + SHOOT_ENTITY_STATUS_CHANCE:
		return Reward.new(SHOOT_ENTITY_STATUS, Rarity.generate_rarity())
	elif reward_type == WEAPON or reward_type == 0 and random_type <= DEMON_PASSIVITY_CHANCE + WEAPON_PASSIVITY_CHANCE + SHOOT_ENTITY_STATUS_CHANCE + WEAPON_CHANCE:
		return Reward.new(WEAPON, Rarity.generate_rarity())
	else:
		return Reward.new(ACTIVITY, Rarity.generate_rarity())
