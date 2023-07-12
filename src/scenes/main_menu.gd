## This is the first scene of [SceneHandler]. It has buttons such as Play, Quit, Settings, City.
## In center there's scroll container for choosing a demon to play. (WIP: create Demon resource class)
class_name MainMenu
extends Control

@export var _play_button: Button ## This button goes to [GameScene].
@export var _settings_menu: SettingsMenu


func _ready() -> void:
	assert(_play_button and _settings_menu)
	_settings_menu.hide()
	update_play_button_disabled()
	if not Global.game_res_loaded:
		Preloader.loaded.connect(
				func():
					Global.game_res_loaded = true
					update_play_button_disabled()
		, CONNECT_ONE_SHOT)
		Preloader.start_preload()
	
	if not GameInfo.is_run_seed_generated:
		GameInfo.generate_game_info()
#		GameInfo.is_run_seed_generated

## This method updates state of [member _play_button].
func update_play_button_disabled():
	var is_ok: bool = Global.game_res_loaded and true
	_play_button.disabled = not is_ok


func _on_quit_button_pressed() -> void:
	get_tree().quit()


func _on_play_button_pressed() -> void:
	Global.switch_to_scene(Preloader.game_scene)


func _on_settings_button_pressed() -> void:
	_settings_menu.show()


func _on_city_button_pressed() -> void:
	pass # Replace with function body.
