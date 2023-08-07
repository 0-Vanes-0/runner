## This is the first scene of [SceneHandler]. It has buttons such as Play, Quit, Settings, City.
## In center there's scroll container for choosing a demon to play. (WIP: create Demon resource class)
class_name MainMenu
extends Control

@export var _play_button: Button ## This button goes to [GameScene].
@export var _settings_menu: SettingsMenu
@export var _demons_hboxcontainer: HBoxContainer
@export var _demon_info_label: RichTextLabel


func _ready() -> void:
	assert(_play_button and _settings_menu and _demons_hboxcontainer and _demon_info_label)
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
		GameInfo.is_run_seed_generated = true
	
	# Remove this loop later
	for child in _demons_hboxcontainer.get_children():
		child.queue_free()
	
	for i in GameInfo.demon_datas.size():
		var button: DemonButton = Preloader.choose_demon_button.instantiate() as DemonButton
		var texture_rect := button.get_child(0).get_child(0) as TextureRect
		texture_rect.texture = GameInfo.demon_datas[i].skin_resource.sprite_frames.get_frame_texture("default", 0)
		texture_rect.modulate = GameInfo.demon_datas[i].color
		button.button_group = Preloader.main_menu_button_group
		_demons_hboxcontainer.add_child(button)
		button.label.text = str(i + 1)
		
		button.toggled.connect(
				func(button_pressed: bool):
					if button_pressed:
						Global.player_data = GameInfo.demon_datas[i]
						_demon_info_label.clear()
						_demon_info_label.push_paragraph(HORIZONTAL_ALIGNMENT_CENTER)
						_demon_info_label.append_text(GameInfo.demon_datas[i].get_description())
						_demon_info_label.pop()
		)
		if i == 1:
			button.button_pressed = true
		else:
			button.button_pressed = false

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
