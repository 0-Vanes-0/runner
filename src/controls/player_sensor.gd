class_name PlayerSensor
extends Marker2D

signal swipe(direction: Vector2)
signal tap_up
signal tap_down

const SWIPE_MAX_DIAGONAL_SLOPE := 1.35
const SWIPE_MAX_TIME := 0.25 # Else it's drag gesture.
const TAP_MAX_TIME := 0.1
const TAP_MAX_VECTOR := Vector2.ONE * 10

var _timer: float = 0.0
var _is_timer_active: bool = false
var _touch_start_position: Vector2
var _size: Vector2


func _ready() -> void:
	self.position = Vector2.ZERO
	_size.x = Global.screen_width / 2
	_size.y = Global.screen_height


func _process(delta: float) -> void:
	if _is_timer_active:
		_timer += delta


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventScreenTouch:
		if self.position < event.position and event.position < self.position + _size:
			if event.pressed:
				_is_timer_active = true
				_touch_start_position = event.position
			else:
				_is_timer_active = false
				var vector: Vector2 = abs(event.position - _touch_start_position)
				if _timer <= TAP_MAX_TIME and vector.length_squared() <= TAP_MAX_VECTOR.length_squared():
					if event.position.y < Global.screen_height / 2:
						tap_up.emit()
					else:
						tap_down.emit()
				elif _timer <= SWIPE_MAX_TIME:
					var direction := Vector2(event.position - _touch_start_position).normalized()
					if abs(direction.x) + abs(direction.y) < SWIPE_MAX_DIAGONAL_SLOPE:
						if abs(direction.x) > abs(direction.y):
							swipe.emit(Vector2(sign(direction.x), 0))
						else: 
							swipe.emit(Vector2(0, sign(direction.y)))
				_timer = 0.0
				_touch_start_position = Vector2.ZERO
	elif event is InputEventKey:
		if event.is_action("jump_up"):
			tap_up.emit()
		
		elif event.is_action("jump_down"):
			tap_down.emit()
		
		elif event.is_action("dodge"):
			swipe.emit(Vector2.RIGHT)
		
		elif event.is_action("ability"):
			swipe.emit(Vector2.UP)
		
		elif event.is_action("reload"):
			swipe.emit(Vector2.DOWN)
		
		elif event.is_action("switch_weapon"):
			swipe.emit(Vector2.LEFT)
