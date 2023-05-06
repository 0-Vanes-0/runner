extends Label


func _ready():
	self.label_settings.font_size = Global.screen_height / 20


func _process(delta):
	self.text = str(Engine.get_frames_per_second())
