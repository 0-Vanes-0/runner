class_name LeftMenu
extends VBoxContainer

@export var meter_label: Label
@export var hp_bar: SnappedProgressBar
@export var stamina_bar: SnappedProgressBar
@export var ammo_bar: SnappedProgressBar
var has_connects: bool = false


func _ready() -> void:
	assert(meter_label and hp_bar and stamina_bar and ammo_bar)


func _process(delta: float) -> void:
	var player := Global.player as Player
	if is_instance_valid(player) and has_connects:
		meter_label.text = str(player.platforms_left) + " m"
		
		hp_bar.value = player.health_comp.health
		stamina_bar.value = player.stamina
		ammo_bar.value = player.weapon.ammo if player.weapon.ammo_max > 1 else 1


func init_connections():
	var player := Global.player as Player
	player.hp_max_changed.connect(
			func(value: int):
				hp_bar.set_max_value(value)
	)
	player.stamina_max_changed.connect(
			func(value: int):
				stamina_bar.set_max_value(value)
	)
	player.ammo_max_changed.connect(
			func(value: int):
				ammo_bar.set_max_value(value, player.weapon.get_ammo_snap_step())
	)
	has_connects = true
	
	hp_bar.set_max_value(int(player.health_comp.health_max))
	stamina_bar.set_max_value(int(player.stamina_max))
	ammo_bar.set_max_value(int(player.weapon.ammo_max), player.weapon.get_ammo_snap_step())
