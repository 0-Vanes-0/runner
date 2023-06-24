extends Control

@export var play_button: Button


func _ready() -> void:
	assert(play_button)
	play_button.visible = false
	Preloader.loaded.connect(_on_loaded)
	Preloader.start_preload()


func _on_loaded():
	play_button.visible = true


func _on_button_pressed():
	get_tree().change_scene_to_packed(Preloader.game_scene)


func _on_quit_button_pressed() -> void:
	get_tree().quit()
