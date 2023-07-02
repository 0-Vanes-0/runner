class_name PauseMenu
extends Control

@export var settings_menu: SettingsMenu

func  _ready() -> void:
	assert(settings_menu)


func _on_resume_button_pressed() -> void:
	get_tree().paused = false
	self.hide()


func _on_settings_button_pressed() -> void:
	settings_menu.show()


func _on_main_menu_button_pressed() -> void:
	get_tree().paused = false
	Global.switch_to_scene(Preloader.main_menu_scene)
