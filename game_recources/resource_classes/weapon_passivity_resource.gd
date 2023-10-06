class_name WeaponPassivityResource
extends Resource

enum Types {
	NONE = 0,
	DAMAGE_BUFF = 11, SHOOT_RATE_BUFF = 12,
	AMMO_BUFF = 21, RELOAD_TIME_BUFF = 22,
}
@export var type: Types = Types.NONE
@export_group("Values", "value_")
@export_range(0, 100, 0.1) var value_normal: float
@export_range(0, 100, 0.1) var value_rare: float
@export_range(0, 100, 0.1) var value_epic: float
@export_range(0, 100, 0.1) var value_legendary: float

const _NAMES := {
	Types.DAMAGE_BUFF: "DMG +_%",
	Types.SHOOT_RATE_BUFF: "DMG +_%",
	Types.AMMO_BUFF: "AMM +_%",
	Types.RELOAD_TIME_BUFF: "DMG +_%",
}


func get_value(rarity: Rarity) -> float:
	match rarity.get_type():
		Rarity.NORMAL:
			return value_normal
		Rarity.RARE:
			return value_rare
		Rarity.EPIC:
			return value_epic
		Rarity.LEGENDARY:
			return value_legendary
		_:
			print_debug("Wrong rarity type: ", rarity.get_type())
			return 0.0


static func get_text(type: Types, value: float) -> String:
	var text: String = _NAMES.get(type)
	text = text.replace("_", str(value))
	return text
