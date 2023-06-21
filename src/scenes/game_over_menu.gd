class_name GameOverMenu
extends Control

signal restart_called

@export var panel: Panel
@export var anim_player: AnimationPlayer
@export var left_label: RichTextLabel
var kills_count: int


func _ready() -> void:
	assert(panel and anim_player and left_label)
	
	self.add_theme_constant_override("margin_top", Global.screen_height / 6)
	self.add_theme_constant_override("margin_right", Global.screen_width / 6)
	self.add_theme_constant_override("margin_bottom", Global.screen_height / 6)
	self.add_theme_constant_override("margin_left", Global.screen_width / 6)
	
	panel.custom_minimum_size = Vector2.ZERO
	
	self.visible = false


func appear():
	self.visible = true
	anim_player.play("start")
	left_label.text = "Enemies killed: " + str(Global.kills_count)


func _on_restart_button_pressed() -> void:
	self.visible = false
	restart_called.emit()


func _on_quit_button_pressed() -> void:
	get_tree().quit()
