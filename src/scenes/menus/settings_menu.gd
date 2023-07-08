class_name SettingsMenu
extends Control

@export var dodge_swipe_button: CheckButton
@export var reload_swipe_button: CheckButton
@export var switch_weapon_swipe_button: CheckButton
@export var activity_swipe_button: CheckButton


func _ready() -> void:
	assert(dodge_swipe_button and reload_swipe_button and switch_weapon_swipe_button and activity_swipe_button)
	dodge_swipe_button.set_pressed_no_signal(Global.settings[Text.CONTROLS][Text.DODGE_SWIPE])
	reload_swipe_button.set_pressed_no_signal(Global.settings[Text.CONTROLS][Text.RELOAD_SWIPE])
	switch_weapon_swipe_button.set_pressed_no_signal(Global.settings[Text.CONTROLS][Text.SWITCH_WEAPON_SWIPE])
	activity_swipe_button.set_pressed_no_signal(Global.settings[Text.CONTROLS][Text.ACTIVITY_SWIPE])


func _on_back_button_pressed() -> void:
	Global.need_apply_settings.emit()
	self.hide()


func _on_dodge_swipe_toggled(button_pressed: bool) -> void:
	Global.settings[Text.CONTROLS][Text.DODGE_SWIPE] = button_pressed
	SaveLoad.save_settings(Global.settings)


func _on_reload_swipe_toggled(button_pressed: bool) -> void:
	Global.settings[Text.CONTROLS][Text.RELOAD_SWIPE] = button_pressed
	SaveLoad.save_settings(Global.settings)


func _on_switch_swipe_toggled(button_pressed: bool) -> void:
	Global.settings[Text.CONTROLS][Text.SWITCH_WEAPON_SWIPE] = button_pressed
	SaveLoad.save_settings(Global.settings)


func _on_activity_swipe_toggled(button_pressed: bool) -> void:
	Global.settings[Text.CONTROLS][Text.ACTIVITY_SWIPE] = button_pressed
	SaveLoad.save_settings(Global.settings)
