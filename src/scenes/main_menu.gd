extends Control

@export var play_button: Button


func _ready() -> void:
	assert(play_button)
	update_play_button_visible()
	if not Global.game_res_loaded:
		Preloader.loaded.connect(
				func():
					Global.game_res_loaded = true
					update_play_button_visible()
		, CONNECT_ONE_SHOT)
		Preloader.start_preload()
	
	if not GameInfo.is_run_seed_generated:
		GameInfo.generate_game_info()
#		GameInfo.is_run_seed_generated


func update_play_button_visible():
	play_button.visible = Global.game_res_loaded


func _on_button_pressed() -> void:
	get_tree().change_scene_to_packed(Preloader.game_scene)


func _on_quit_button_pressed() -> void:
	get_tree().quit()
