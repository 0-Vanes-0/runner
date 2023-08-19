## This menu appears on pause with [kbd]Escape[/kbd] on Desktop or [kbd]Back[/kbd] on Android.
## [br]It contains buttons: "Resume", "Settings", "Go to menu".
class_name PauseMenu
extends Control

@export var _settings_menu: SettingsMenu
@export var _label: RichTextLabel


func  _ready() -> void:
	assert(_settings_menu and _label)


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
		var text := Global.player.get_current_stats()
		_label.clear()
		_label.append_text("Passivities:\n")
		_label.append_text(text if not text.is_empty() else "No stats.")
