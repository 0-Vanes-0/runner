class_name PlayerSensor
extends Marker2D

signal movement(direction: Vector2)

const SWIPE_MAX_DIAGONAL_SLOPE := 1.35
const SWIPE_MAX_TIME := 0.2 # Else it's drag gesture.

var _timer: float = 0.0
var _is_timer_active: bool = false
var _touch_start_position: Vector2
var _size: Vector2


func _ready():
	self.position = Vector2.ZERO
	_size.x = Global.screen_width / 2
	_size.y = Global.screen_height


func _process(delta):
	if _is_timer_active:
		_timer += delta


func _unhandled_input(event):
	if event is InputEventScreenTouch:
		if self.position < event.position and event.position < self.position + _size:
			if event.pressed:
				_is_timer_active = true
				_touch_start_position = event.position
			else:
				_is_timer_active = false
				if _timer <= SWIPE_MAX_TIME:
					var direction := Vector2(event.position - _touch_start_position).normalized()
					if abs(direction.x) + abs(direction.y) < SWIPE_MAX_DIAGONAL_SLOPE:
						if abs(direction.x) > abs(direction.y):
							movement.emit(Vector2(sign(direction.x), 0))
						else: 
							movement.emit(Vector2(0, sign(direction.y)))
				_timer = 0.0
				_touch_start_position = Vector2.ZERO
	elif event is InputEventKey:
		if event.is_action("jump_up"):
			movement.emit(Vector2.UP)
		elif event.is_action("jump_down"):
			movement.emit(Vector2.DOWN)
		elif event.is_action("dodge"):
			movement.emit(Vector2.RIGHT)
