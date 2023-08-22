extends Label


func _ready() -> void:
	self.label_settings.font_size = Global.SCREEN_HEIGHT / 25
	self.label_settings.outline_color = Color.BLACK
	self.label_settings.outline_size = 4


func _process(delta: float) -> void:
	if is_instance_valid(Global.player):
		self.text = ( str(Engine.get_frames_per_second()) + "FPS" )
