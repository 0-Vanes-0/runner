class_name ShootSensor
extends Marker2D

signal shoot_activated(target_position: Vector2)
signal shoot_disabled()

var _size: Vector2
var _is_shooting: bool
var _shoot_position: Vector2


func _ready() -> void:
	self.position = Vector2(Global.SCREEN_WIDTH / 2, 0)
	_size.x = Global.SCREEN_WIDTH / 2
	_size.y = Global.SCREEN_HEIGHT


func _physics_process(delta: float) -> void:
	if _is_shooting:
		shoot_activated.emit(_shoot_position)


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventScreenTouch:
		if _is_position_within(event.position):
			if event.pressed:
				_shoot_position = event.position
				_is_shooting = true
			else:
				_is_shooting = false
				shoot_disabled.emit()
	elif event is InputEventScreenDrag:
		if _is_position_within(event.position) and _is_shooting:
			_shoot_position = event.position


func _is_position_within(position: Vector2) -> bool:
	return self.position < position and position < self.position + _size
