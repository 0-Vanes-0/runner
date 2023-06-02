class_name ShootSensor
extends Marker2D

signal shoot_activated(target_position: Vector2)

var _size: Vector2
var _is_shooting: bool
var _shoot_position: Vector2


func _ready():
	self.position = Vector2(Global.screen_width / 2, 0)
	_size.x = Global.screen_width / 2
	_size.y = Global.screen_height


func _physics_process(_delta):
	if _is_shooting:
		shoot_activated.emit(_shoot_position)


func _unhandled_input(event):
	if event is InputEventScreenTouch:
		if _is_position_within(event.position):
			if event.pressed:
				_shoot_position = event.position
				_is_shooting = true
			else:
				_is_shooting = false
	elif event is InputEventScreenDrag:
		if _is_position_within(event.position) and _is_shooting:
			_shoot_position = event.position


func _is_position_within(position: Vector2) -> bool:
	return self.position < position and position < self.position + _size
