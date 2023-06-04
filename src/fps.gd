extends Label


func _ready() -> void:
	self.label_settings.font_size = Global.screen_height / 20


func _process(delta: float) -> void:
	self.text = str(Engine.get_frames_per_second())
