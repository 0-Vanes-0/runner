## This menu appears on 0 health of player's [HealthComponent]. It prints results of a run.
class_name GameOverMenu
extends Control

## This signal is emitted when "Restart" button pressed. Equivalent of pressing "Play" at [MainMenu].[br]
## This is test signal, it will be removed later.
signal restart_called

@export var _panel: Panel
@export var _anim_player: AnimationPlayer
@export var _left_label: RichTextLabel


func _ready() -> void:
	assert(_panel and _anim_player and _left_label)
	
	self.add_theme_constant_override("margin_top", Global.SCREEN_HEIGHT / 6)
	self.add_theme_constant_override("margin_right", Global.SCREEN_WIDTH / 6)
	self.add_theme_constant_override("margin_bottom", Global.SCREEN_HEIGHT / 6)
	self.add_theme_constant_override("margin_left", Global.SCREEN_WIDTH / 6)
	
	_panel.custom_minimum_size = Vector2.ZERO
	
	self.visible = false

## Shows this menu and starts animation.
func appear():
	self.visible = true
	_anim_player.play("start")
	_left_label.text = (
			"Enemies killed: " + str(GameInfo.kills_count) + "\n"
			+ "Died on level " + str(GameInfo.level_number) + " in biome " + str(GameInfo.biome_number) + "\n"
	)


func _on_restart_button_pressed() -> void:
	self.visible = false
	restart_called.emit()


func _on_quit_button_pressed() -> void:
	get_tree().change_scene_to_packed(Preloader.main_menu_scene)
