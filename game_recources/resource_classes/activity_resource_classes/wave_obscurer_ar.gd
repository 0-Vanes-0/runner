class_name WaveObcurerAR
extends ActivityResource


func action():
	var enemies := Global.get_game_scene().get_tree().get_nodes_in_group(Text.ENEMY_GROUP)
	for enemy in enemies as Array[Enemy]:
		enemy.health_comp.take_damage(value_normal)


func action_end():
	pass
