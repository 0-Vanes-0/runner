class_name Rarity
extends Object

const NORMAL: int = 1
const RARE: int = 2
const EPIC: int = 3
const LEGENDARY: int = 4

const NAMES := {
	NORMAL: "Normal",
	RARE: "Rare",
	EPIC: "Epic",
	LEGENDARY: "Legendary",
}
const COLORS := {
	NORMAL: Color.WHITE,
	RARE: Color.CHOCOLATE,
	EPIC: Color.YELLOW,
	LEGENDARY: Color.RED,
}

const NORMAL_CHANCE: int = 50
const RARE_CHANCE: int = 30
const EPIC_CHANCE: int = 15
const LEGENDARY_CHANCE: int = 5
static var CHANCES_SUM: int = NORMAL_CHANCE + RARE_CHANCE + EPIC_CHANCE + LEGENDARY_CHANCE

var _type: int = 0


func _init(type: int) -> void:
	_type = type


func get_type() -> int:
	return _type


func get_name() -> String:
	return NAMES[_type]


static func generate_rarity() -> Rarity:
	var random_value: int = randi_range(1, CHANCES_SUM)
	if random_value < NORMAL_CHANCE:
		return Rarity.new(NORMAL)
	elif random_value < NORMAL_CHANCE + RARE_CHANCE:
		return Rarity.new(RARE)
	elif random_value < NORMAL_CHANCE + RARE_CHANCE + EPIC_CHANCE:
		return Rarity.new(EPIC)
	else:
		return Rarity.new(LEGENDARY)


static func get_color_hex(rarity: Rarity) -> String:
	return (COLORS[rarity.get_type()] as Color).to_html()
