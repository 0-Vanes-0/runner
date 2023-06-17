class_name GameOverMenu
extends Control

signal restart_called

@onready var panel := $Panel as Panel
@onready var anim_player := $AnimationPlayer as AnimationPlayer


func _ready() -> void:
	self.add_theme_constant_override("margin_top", Global.screen_height / 6)
	self.add_theme_constant_override("margin_right", Global.screen_width / 6)
	self.add_theme_constant_override("margin_bottom", Global.screen_height / 6)
	self.add_theme_constant_override("margin_left", Global.screen_width / 6)
	
	panel.custom_minimum_size = Vector2.ZERO
	
	self.visible = false


func appear():
	self.visible = true
	anim_player.play("start")


func _on_restart_button_pressed() -> void:
	self.visible = false
	restart_called.emit()
