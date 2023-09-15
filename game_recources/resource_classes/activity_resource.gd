class_name ActivityResource
extends Resource

@export var name: String = "My Activity"
@export_multiline var description: String = "___ $1 ___$2.\nReload: $3 s."
@export var texture: Texture2D
@export_group("Values", "value_")
@export var value_normal: int = 0
@export var value_rare: int = 0
@export var value_epic: int = 0
@export var value_legendary: int = 0
@export_group("")
@export_range(0.0, 30.0, 0.1) var reload_time: float = 10.0
@export_range(0.0, 30.0, 0.1) var duration_time: float = 0.0


func action(rarity: Rarity): # virtual
	assert(false)


func action_end(rarity: Rarity): # virtual
	assert(false)


func get_value(rarity: Rarity) -> int:
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
			return 0


func get_description(rarity: Rarity) -> String:
	var text := String(description)
	text = text.replace(
			"$1", 
			"[color=#" + Rarity.get_color_hex(rarity) + "]" 
			+ str(get_value(rarity))
			+ "[/color]"
	)
	text = text.replace(
			"$2", 
			" during " + str(duration_time).pad_decimals(2) + " s"
	)
	text = text.replace("$3", str(reload_time).pad_decimals(2))
	return text


func get_preview() -> Texture2D:
	return texture
