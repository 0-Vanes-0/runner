## This menu appears on pause with [kbd]Escape[/kbd] on Desktop or [kbd]Back[/kbd] on Android.
## [br]It contains buttons: "Resume", "Settings", "Go to menu".
class_name PauseMenu
extends Control

@export var _settings_menu: SettingsMenu

func  _ready() -> void:
	assert(_settings_menu)


func _on_resume_button_pressed() -> void:
	get_tree().paused = false
	self.hide()


func _on_settings_button_pressed() -> void:
	_settings_menu.show()


func _on_main_menu_button_pressed() -> void:
	get_tree().paused = false
	Global.switch_to_scene(Preloader.main_menu_scene)
