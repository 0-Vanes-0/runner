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


func _init(type: int, rarity: Rarity) -> void:
	_type = type
	match type:
		DEMON_PASSIVITY:
			_value = Preloader.reward_resource.get_demon_passivity(rarity)
		WEAPON_PASSIVITY:
			_value = Preloader.reward_resource.get_weapon_passivity(rarity)
		SHOOT_ENTITY_STATUS:
			_value = Preloader.reward_resource.get_status(rarity)
		WEAPON:
			_value = Preloader.reward_resource.get_weapon(rarity)
		ACTIVITY:
			_value = Preloader.reward_resource.get_activity(rarity)
		_:
			assert(false, "WRONG TYPE OF REWARD: " + str(type))


static func generate_reward() -> Reward:
	var random_type := randi_range(1, CHANCES_SUM)
	if random_type <= DEMON_PASSIVITY_CHANCE:
		return Reward.new(DEMON_PASSIVITY, Rarity.generate_rarity())
	elif random_type <= DEMON_PASSIVITY_CHANCE + WEAPON_PASSIVITY_CHANCE:
		return Reward.new(WEAPON_PASSIVITY, Rarity.generate_rarity())
	elif random_type <= DEMON_PASSIVITY_CHANCE + WEAPON_PASSIVITY_CHANCE + SHOOT_ENTITY_STATUS_CHANCE:
		return Reward.new(SHOOT_ENTITY_STATUS, Rarity.generate_rarity())
	elif random_type <= DEMON_PASSIVITY_CHANCE + WEAPON_PASSIVITY_CHANCE + SHOOT_ENTITY_STATUS_CHANCE + WEAPON_CHANCE:
		return Reward.new(WEAPON, Rarity.generate_rarity())
	else:
		return Reward.new(ACTIVITY, Rarity.generate_rarity())
