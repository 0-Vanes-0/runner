extends Sprite2D

@export var player_control: PlayerControl
@export var shoot_control: ShootControl


func _ready():
	if player_control != null:
		player_control.swipe.connect(_move_vert)
	else:
		print_debug("PlayerControl is null")
	
	if shoot_control != null:
		shoot_control.tap.connect(_tap_shoot)
	else:
		print_debug("ShootControl is null")


func _process(delta):
	pass


func _move_vert(direction: Vector2):
	self.position += direction * 100


func _tap_shoot(position: Vector2):
	var spawn_spr := Sprite2D.new()
	spawn_spr.texture = preload("res://assets/sprites/fire_orb.png")
	spawn_spr.position = position
	get_tree().current_scene.add_child(spawn_spr)
