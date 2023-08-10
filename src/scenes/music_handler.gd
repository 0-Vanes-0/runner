class_name MusicHandler
extends AudioStreamPlayer

const FADE_OUT_TIME := 1.0
@export var main_menu_music: AudioStreamMP3
@export var game_music: AudioStreamMP3
var volume := -20.0
var is_music_on: bool


func _ready() -> void:
	assert(main_menu_music and game_music)
	var scene_handler := get_parent() as SceneHandler
	scene_handler.scene_changed.connect(_on_scene_changed)
	self.volume_db = volume
	is_music_on = Global.settings[Text.AUDIO][Text.MUSIC]
	
	Global.need_apply_settings.connect(
			func():
				if Global.settings[Text.AUDIO][Text.MUSIC] == true:
					is_music_on = true
					self.play()
				else:
					is_music_on = false
					self.stop()
	)


func _on_scene_changed(current_scene: Node):
	if current_scene is MainMenu:
		self.stream = main_menu_music
	elif current_scene is GameScene:
		_transition_current_volume()
		await get_tree().create_timer(FADE_OUT_TIME).timeout
		self.stream = game_music
	
	if not self.playing and is_music_on:
		self.play()


func _transition_current_volume():
	var tween := create_tween()
	tween.tween_property(
			self, "volume_db",
			-80,
			FADE_OUT_TIME
	)
	tween.tween_property(
			self, "volume_db",
			volume,
			0.0
	)
