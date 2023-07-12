extends Label


func _ready() -> void:
	self.label_settings.font_size = Global.SCREEN_HEIGHT / 25
	self.label_settings.outline_color = Color.BLACK
	self.label_settings.outline_size = 4


func _process(delta: float) -> void:
	if is_instance_valid(Global.player):
		self.text = (
				str(Engine.get_frames_per_second()) + "FPS | " + str( Global.player.platforms_left ) + " plats left of level " + str( GameInfo.level_number ) + "\n"
				+ str( Global.player.health_comp.health ) + "HP | " + str( floori(Global.player.stamina) ) + "STM" + "\n"
				+ str( Global.player.weapon.ammo )+ "/" + str( Global.player.weapon.ammo_max ) + "AMM" + str( "+" if Global.player.weapon.is_reloading else "" ) + "\n"
				+  "\n"
		)
