class_name DemonPassivityResource
extends Resource

enum Types {
	NONE = 0,
	HP_BUFF = 11,
	STAMINA_BUFF = 21, GRAVITY_BUFF = 22, SPEED_BUFF = 23,
}
@export var type: Types = Types.NONE
@export_group("Values", "value_")
@export_range(0, 100, 0.1) var value_normal: float
@export_range(0, 100, 0.1) var value_rare: float
@export_range(0, 100, 0.1) var value_epic: float
@export_range(0, 100, 0.1) var value_legendary: float

const _NAMES := {
	Types.HP_BUFF: "HP +_%",
	Types.STAMINA_BUFF: "STM +_%",
	Types.GRAVITY_BUFF: "VRT SPD +_%",
	Types.SPEED_BUFF: "RUN SPD +_%",
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
