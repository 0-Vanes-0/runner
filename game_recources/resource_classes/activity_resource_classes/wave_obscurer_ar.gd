class_name WaveObcurerAR
extends ActivityResource


func action():
	var enemies := Global.get_game_scene().get_tree().get_nodes_in_group(Text.ENEMY_GROUP)
	for enemy in enemies as Array[Enemy]:
		enemy.health_comp.take_damage(self.get_value(self.rarity))


func action_end():
	pass # do nothing
