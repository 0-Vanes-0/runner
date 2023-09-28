## This menu appears manually. It loads and saves settings.
class_name SettingsMenu
extends Control

@export var _apply_button: Button
@export var _sections_vbox: VBoxContainer


func _ready() -> void:
	assert(_apply_button and _sections_vbox)
	# Set buttons state according to settings:
	for section_name in Global.settings.keys() as Array[String]:
		var section := VBoxContainer.new()
		section.name = section_name + "VBox"
		var section_name_label := Label.new()
		section_name_label.name = section_name + "Label"
		section_name_label.text = section_name
		
		section.add_child(section_name_label)
		_sections_vbox.add_child(section)
		
		for setting_name in Global.settings.get(section_name).keys() as Array[String]:
			var switch_button := CheckButton.new()
			switch_button.name = setting_name + "Button"
			switch_button.text = setting_name
			switch_button.toggled.connect(
					func(button_pressed: bool):
						Global.settings[section_name][setting_name] = button_pressed
						SaveLoad.save_settings()
						_apply_button.disabled = false
			)
			switch_button.set_pressed_no_signal(Global.settings.get(section_name).get(setting_name))
			section.add_child(switch_button)


func _on_back_button_pressed() -> void:
	if not _apply_button.disabled:
		Global.need_apply_settings.emit()
		_apply_button.disabled = true
	self.hide()


func _on_apply_button_pressed() -> void:
	Global.need_apply_settings.emit()
	_apply_button.disabled = true


func _on_rr_button_pressed() -> void:
	SaveLoad.erase_settings()
	Global.setup()
	get_tree().reload_current_scene()
