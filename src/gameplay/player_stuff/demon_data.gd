class_name DemonData
extends Object

var _BASE_HP := {
	Rarity.NORMAL: 50,
	Rarity.RARE: 100,
	Rarity.EPIC: 200,
	Rarity.LEGENDARY: 500,
}
var _BASE_SPEED := {
	Rarity.NORMAL: Platform.SIZE.x * 1.5,
	Rarity.RARE: Platform.SIZE.x * 2.0,
	Rarity.EPIC: Platform.SIZE.x * 2.5,
	Rarity.LEGENDARY: Platform.SIZE.x * 3.0,
}
var _BASE_STAMINA_REGEN := {
	Rarity.NORMAL: 15,
	Rarity.RARE: 18,
	Rarity.EPIC: 23,
	Rarity.LEGENDARY: 30,
}
var _BASE_DODGES_IN_STAMINA := {
	Rarity.NORMAL: 4,
	Rarity.RARE: 5,
	Rarity.EPIC: 7,
	Rarity.LEGENDARY: 10,
}
var _BASE_JUMPS_IN_STAMINA := {
	Rarity.NORMAL: 6,
	Rarity.RARE: 7,
	Rarity.EPIC: 9,
	Rarity.LEGENDARY: 12,
}
var _BASE_GRAVITY := {
	Rarity.NORMAL: 1000,
	Rarity.RARE: 1500,
	Rarity.EPIC: 2000,
	Rarity.LEGENDARY: 4000,
}
var _RARITY_STATS := {
	Rarity.NORMAL: 5,
	Rarity.RARE: 3,
	Rarity.EPIC: 2,
	Rarity.LEGENDARY: 1,
}

var common_rarity: Rarity
var skin_resource: SkinResource
var color: Color
var weapon_resource: WeaponResource

var rarities: Array[Rarity] = []
var base_hp: int
var base_speed: float
var base_stamina_regen: int
var base_gravity: int
var start_weapon_rarity: Rarity
const STATS_AMOUNT := 5

var base_dodges_in_stamina: int
var base_jumps_in_stamina: int


func _init(rarity: Rarity, skin_resource: SkinResource) -> void:
	self.common_rarity = rarity
	self.skin_resource = skin_resource
	
	self.color = Rarity.COLORS.get(rarity.get_type())
	var order := range(STATS_AMOUNT); order.shuffle()
	rarities.resize(STATS_AMOUNT)
	for i in _RARITY_STATS[rarity.get_type()]:
		var number: int = order.pop_back()
		_assign_with_rarity(number, rarity)
	for i in order:
		_assign_with_rarity(i, Rarity.new(Rarity.NORMAL))
	
	base_dodges_in_stamina = _BASE_DODGES_IN_STAMINA.get(Rarity.NORMAL)
	base_jumps_in_stamina = _BASE_JUMPS_IN_STAMINA.get(Rarity.NORMAL)
	
	self.weapon_resource = Preloader.base_weapon_resources.pick_random()


func get_description() -> String:
	var text := ""
	text += "[color=#" + Rarity.get_color_hex(rarities[0]) + "]" + str(base_hp) + " HP" + "[/color]"
	text += "\t\t"
	text += "[color=#" + Rarity.get_color_hex(rarities[1]) + "]" + str(base_speed) + " SPD" + "[/color]"
	text += "\t\t"
	text += "[color=#" + Rarity.get_color_hex(rarities[2]) + "]" + str(base_stamina_regen) + " STM/s" + "[/color]"
	text += "\t\t"
	text += "[color=#" + Rarity.get_color_hex(rarities[3]) + "]" + str(base_gravity) + " GRV" + "[/color]"
	text += "\n"
	text += "Weapon: " + weapon_resource.name
	text += "\n"
	text += "[color=#" + Rarity.get_color_hex(rarities[4]) + "]" + weapon_resource.get_description(start_weapon_rarity) + "[/color]"
	return text


func _assign_with_rarity(i: int, rarity: Rarity):
	rarities[i] = rarity
	match i:
		0:
			base_hp = _BASE_HP.get(rarity.get_type())
		1:
			base_speed = _BASE_SPEED.get(rarity.get_type())
		2:
			base_stamina_regen = _BASE_STAMINA_REGEN.get(rarity.get_type())
		3:
			base_gravity = _BASE_GRAVITY.get(rarity.get_type())
		4:
			start_weapon_rarity = rarity
		_:
			assert(false, "rarities.size()=" + str(rarities.size()) + " <---> STATS_AMOUNT=" + str(STATS_AMOUNT))
