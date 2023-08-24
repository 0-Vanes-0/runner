## This menu appears on pause with [kbd]Escape[/kbd] on Desktop or [kbd]Back[/kbd] on Android.
## [br]It contains buttons: "Resume", "Settings", "Go to menu".
class_name PauseMenu
extends Control

const FONT_SIZE: int = 36

@export var _settings_menu: SettingsMenu
@export var _tab_container: TabContainer
@export var _info_label: RichTextLabel
@export var _build_label: RichTextLabel
@export var _weapon1_texture_rect: TextureRect
@export var _weapon1_label: RichTextLabel
@export var _weapon2_texture_rect: TextureRect
@export var _weapon2_label: RichTextLabel


func  _ready() -> void:
	assert(_settings_menu and _tab_container and _info_label and _build_label and _weapon1_label and _weapon1_texture_rect and _weapon2_label and _weapon2_texture_rect)
	_info_label.add_theme_font_size_override("normal_font_size", FONT_SIZE)
	_build_label.add_theme_font_size_override("normal_font_size", FONT_SIZE)
	_weapon1_label.add_theme_font_size_override("normal_font_size", FONT_SIZE)
	_weapon2_label.add_theme_font_size_override("normal_font_size", FONT_SIZE)


func _on_resume_button_pressed() -> void:
	get_tree().paused = false
	self.hide()


func _on_settings_button_pressed() -> void:
	_settings_menu.show()


func _on_main_menu_button_pressed() -> void:
	get_tree().paused = false
	Global.switch_to_scene(Preloader.main_menu_scene)


func _on_visibility_changed() -> void:
	if self.visible:
		var player := Global.player as Player
		var data := Global.player_data as DemonData
		
		_info_label.clear()
		_info_label.append_text("Your stats:")
		_info_label.append_text("\n")
		_info_label.append_text(
				"HP: " + str(player.health_comp.health) + "/" + str(player.health_comp.health_max) + " (" + str(data.base_hp) + ")"
		)
		_info_label.append_text("\n")
		_info_label.append_text(
				"STM: " + str( roundi(player.stamina) ) + "/" + str(player.stamina_max) + " (" + str(data.base_stamina) + ")"
		)
		_info_label.append_text("\n")
		_info_label.append_text(
				"STM RGN: " + str(player.stamina_regen) + "/s (" + str(data.base_stamina_regen) + ")"
		)
		_info_label.append_text("\n")
		_info_label.append_text(
				"SPD: " + player.get_meters_per_sec() + " m/s (" + String.num(data.base_speed / Platform.SIZE.x, 2) + " m/s)"
		)
		_info_label.append_text("\n")
		_info_label.append_text(
				"VRT SPD: " + player.get_gravity_percent() + "%"
		)
		_info_label.append_text("\n")
		
		var text := player.get_current_stats()
		_build_label.clear()
		_build_label.append_text("Passivities:\n")
		_build_label.append_text(text if not text.is_empty() else "No stats.")
		
		var weapon1 := player.weapon1
		_weapon1_texture_rect.texture = weapon1.get_preview()
		_weapon1_label.clear()
		_weapon1_label.append_text(
				weapon1.get_description()
		)
		
		if player.weapon2 != null:
			var weapon2 := player.weapon2
			_weapon2_texture_rect.texture = weapon2.get_preview()


func _on_stats_tab_button_toggled(button_pressed: bool) -> void:
	if button_pressed == true:
		_tab_container.current_tab = 0


func _on_weapons_tab_button_toggled(button_pressed: bool) -> void:
	if button_pressed == true:
		_tab_container.current_tab = 1


func _on_activity_tab_button_toggled(button_pressed: bool) -> void:
	if button_pressed == true:
		_tab_container.current_tab = 2
