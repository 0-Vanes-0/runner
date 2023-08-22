## This menu appears on pause with [kbd]Escape[/kbd] on Desktop or [kbd]Back[/kbd] on Android.
## [br]It contains buttons: "Resume", "Settings", "Go to menu".
class_name PauseMenu
extends Control

@export var _settings_menu: SettingsMenu
@export var _info_label: RichTextLabel
@export var _build_label: RichTextLabel


func  _ready() -> void:
	assert(_settings_menu and _info_label and _build_label)


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
		_info_label.append_text(
				"HP: " + str(player.health_comp.health) + "/" + str(player.health_comp.health_max) + " (" + str(data.base_hp) + ")"
		)
		_info_label.append_text("\n")
		_info_label.append_text(
				"STM: " + str( roundi(player.stamina) ) + "/" + str(player.stamina_max) #+ " (" + str(data.base_stamina) + ")"
		)
		_info_label.append_text("\n")
		_info_label.append_text(
				"STM RGN: " + str(player.stamina_regen) + "/s (" + str(data.base_stamina_regen) + ")"
		)
		_info_label.append_text("\n")
		
		var text := player.get_current_stats()
		_build_label.clear()
		_build_label.append_text("Passivities:\n")
		_build_label.append_text(text if not text.is_empty() else "No stats.")
