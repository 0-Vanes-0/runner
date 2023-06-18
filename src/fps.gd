extends Label

var enemies := 0


func _ready() -> void:
	self.label_settings.font_size = Global.screen_height / 25


func _process(delta: float) -> void:
	self.text = (
		str(Engine.get_frames_per_second()) + "fps" + "\n"
		+ str(Global.player.health_comp.health) + " hp" + "\n"
		+ str( floori(Global.player.stamina) ) + " STM" + "\n"
		+ str(enemies) + " kills"
	)


func on_enemy_dead():
	enemies += 1
