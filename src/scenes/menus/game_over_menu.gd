class_name GameOverMenu
extends Control

signal restart_called

@export var panel: Panel
@export var anim_player: AnimationPlayer
@export var left_label: RichTextLabel


func _ready() -> void:
	assert(panel and anim_player and left_label)
	
	self.add_theme_constant_override("margin_top", Global.SCREEN_HEIGHT / 6)
	self.add_theme_constant_override("margin_right", Global.SCREEN_WIDTH / 6)
	self.add_theme_constant_override("margin_bottom", Global.SCREEN_HEIGHT / 6)
	self.add_theme_constant_override("margin_left", Global.SCREEN_WIDTH / 6)
	
	panel.custom_minimum_size = Vector2.ZERO
	
	self.visible = false


func appear():
	self.visible = true
	anim_player.play("start")
	left_label.text = (
			"Enemies killed: " + str(GameInfo.kills_count) + "\n"
			+ "Died on level " + str(GameInfo.level_number) + " in biome " + str(GameInfo.biome_number) + "\n"
	)


func _on_restart_button_pressed() -> void:
	self.visible = false
	restart_called.emit()


func _on_quit_button_pressed() -> void:
	get_tree().change_scene_to_packed(Preloader.main_menu_scene)
