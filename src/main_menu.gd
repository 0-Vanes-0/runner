extends Control


func _ready():
	$Button.disabled = true
	Preloader.loaded.connect(_on_loaded)
	Preloader.start_preload()


func _on_loaded():
	$Button.disabled = false


func _on_button_pressed():
	get_tree().change_scene_to_packed(Preloader.game_scene)
