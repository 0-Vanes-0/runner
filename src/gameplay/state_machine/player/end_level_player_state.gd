class_name EndLevelPlayerState
extends PlayerState

const ANIM_RUN := "run"
const ANIM_DEFAULT := "default"


func enter():
	super.enter()
#	var tween := get_tree().create_tween()
	player.sprite.play(ANIM_DEFAULT)
#	player.
#	?.portal_chosen.connect(
#		func():
#			player.sprite.play(ANIM_RUN)
#			tween.tween_property(player, "position", ...)
#			await tween.tween_finished
#			start new level???
#	)


func physics_update(delta: float):
	apply_player_gravity(delta)


func update(delta: float):
	if not player.sprite.is_playing():
		player.sprite.play()
