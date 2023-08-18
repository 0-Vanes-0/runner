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
var _BASE_JUMPS_STAMINA_COST := { # ???
	Rarity.NORMAL: 20,
	Rarity.RARE: 15,
	Rarity.EPIC: 12,
	Rarity.LEGENDARY: 10,
}
var _BASE_DODGE_STAMINA_COST := { # ???
	Rarity.NORMAL: 30,
	Rarity.RARE: 25,
	Rarity.EPIC: 20,
	Rarity.LEGENDARY: 16,
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


func _init(rarity: Rarity, skin_resource: SkinResource) -> void:
	self.common_rarity = rarity
	self.skin_resource = skin_resource
	
	self.color = Rarity.COLORS.get(rarity.get_type())
	var order := range(5); order.shuffle()
	rarities.resize(5)
	for i in _RARITY_STATS[rarity.get_type()]:
		var number: int = order.pop_back()
		_assign_with_rarity(number, rarity)
	for i in order:
		_assign_with_rarity(i, Rarity.new(Rarity.NORMAL))
	
	self.weapon_resource = Preloader.base_weapon_resources.pick_random()


func get_description() -> String:
	return (
					   "[color=#" + Rarity.get_color_hex(rarities[0]) + "]" + str(base_hp) + " HP" + "[/color]"
			+ "\t\t" + "[color=#" + Rarity.get_color_hex(rarities[1]) + "]" + str(base_speed) + " SPD" + "[/color]"
			+ "\t\t" + "[color=#" + Rarity.get_color_hex(rarities[2]) + "]" + str(base_stamina_regen) + " STM/s" + "[/color]"
			+ "\t\t" + "[color=#" + Rarity.get_color_hex(rarities[3]) + "]" + str(base_gravity) + " GRV" + "[/color]"
			+ "\n" + "Weapon: " + weapon_resource.name
			+ "\n" + "[color=#" + Rarity.get_color_hex(rarities[4]) + "]" + weapon_resource.get_description(start_weapon_rarity) + "[/color]"
	)


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
