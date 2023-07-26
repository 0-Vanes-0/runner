## This is the first scene of [SceneHandler]. It has buttons such as Play, Quit, Settings, City.
## In center there's scroll container for choosing a demon to play. (WIP: create Demon resource class)
class_name MainMenu
extends Control

@export var _play_button: Button ## This button goes to [GameScene].
@export var _settings_menu: SettingsMenu
@export var _demons_hboxcontainer: HBoxContainer


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
	
	var buttons_array := _demons_hboxcontainer.get_children()
	for i in buttons_array.size():
		var skin: SkinResource
		if randf() > 0.5:
			skin = Preloader.white_skin
		else:
			skin = Preloader.biker_skin
		var color: Color = SkinResource.COLORS.pick_random()
		
		var button: CheckButton = buttons_array[i]
		var texture_rect := button.get_child(0).get_child(0) as TextureRect
		texture_rect.texture = skin.sprite_frames.get_frame_texture("default", 0)
		texture_rect.modulate = color
		
		button.toggled.connect(
				func(button_pressed: bool):
					if button_pressed:
						Global.player_data.set_skin(skin, color)
		)
		if i == 1:
			button.button_pressed = true
		else:
			button.button_pressed = false
		
	
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


func _on_faq_button_pressed() -> void:
	$FAQPanel.show()


func _on_faq_panel_gui_input(event: InputEvent) -> void:
	if event.is_pressed():
		$FAQPanel.hide()
