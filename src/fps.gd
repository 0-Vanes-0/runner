extends Label

@export var player: Player
var hp := ""


func _ready() -> void:
	self.label_settings.font_size = Global.screen_height / 20
	assert(player != null)
	
	hp = str(player.health_comp.health)
	player.health_comp.took_damage.connect(
		func():
			hp = str(player.health_comp.health)
	)


func _process(delta: float) -> void:
	self.text = (
		str(Engine.get_frames_per_second()) 
		+ ", " + hp + " hp"
	)
