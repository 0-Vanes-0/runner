extends Label

var player: Player
var hp := ""
var enemies := 0


func _ready() -> void:
	self.label_settings.font_size = Global.screen_height / 20


func _process(delta: float) -> void:
	self.text = (
		str(Engine.get_frames_per_second()) 
		+ ", " + hp + " hp"
		+ ", " + str(enemies) + " enemies killed"
	)


func set_player(player: Player):
	self.player = player
	hp = str(player.health_comp.health)
	player.health_comp.took_damage.connect(
		func():
			hp = str(player.health_comp.health)
	)


func on_enemy_dead():
	enemies += 1
