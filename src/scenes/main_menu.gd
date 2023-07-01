extends Control

@export var play_button: Button
@export var settings_menu: SettingsMenu


func _ready() -> void:
	assert(play_button and settings_menu)
	settings_menu.hide()
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


func _on_quit_button_pressed() -> void:
	get_tree().quit()


func _on_play_button_pressed() -> void:
	Global.switch_to_scene(Preloader.game_scene)


func _on_settings_button_pressed() -> void:
	settings_menu.show()


func _on_city_button_pressed() -> void:
	pass # Replace with function body.
