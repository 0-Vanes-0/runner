class_name DemonPassivityResource
extends Resource

enum Types {
	NONE = 0,
	HP_BUFF = 11,
	STAMINA_BUFF = 21, GRAVITY_BUFF = 22,
	SPEED_BUFF = 31, SPEED_ACC_BUFF = 32,
}
@export var type: Types = Types.NONE
@export_range(0, 100, 0.1) var value: float

const _NAMES := {
	Types.HP_BUFF: "HP +_%",
	Types.STAMINA_BUFF: "STM +_%",
	Types.GRAVITY_BUFF: "VRT SPD +_%",
	Types.SPEED_BUFF: "RUN SPD +_%",
	Types.SPEED_ACC_BUFF: "RUN ACC +_%",
}


static func get_text(type: Types, value: float) -> String:
	var text: String = _NAMES.get(type)
	text = text.replace("_", str(value))
	return text
