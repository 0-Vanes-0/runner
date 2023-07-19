## This class reads all actions from player.
class_name PlayerSensor
extends Marker2D

signal swipe(direction: Vector2) ## Signal for swipe. Argument is Vector2(x, y) where x = 0 or 1 and y = 0 or 1.
signal tap_up ## Signal for tapping at top half of screen.
signal tap_down ## Signal for tapping at bottom half of screen.

const SWIPE_MAX_DIAGONAL_SLOPE := 1.35 ## This constant is a limit of diagonal swipe. Totally diagonal swipe has value 1.44 as sqrt(2). This constant can be changed but 1.35 is best as tested.
const SWIPE_MAX_TIME := 0.25 ## If time is more than that, it's drag gesture.
const TAP_MAX_TIME := 0.1 ## If time is more than that, it's drag or longpress gesture.
const TAP_MAX_VECTOR := Vector2.ONE * 10 ## Tap gesture can have a bit more than Vector2(0, 0), and for that reason this constant exists.

@export var control: Control
@export var dodge_button: SensorButton
@export var reload_button: SensorButton
@export var switch_button: SensorButton
@export var activity_button: SensorButton

var _timer: float = 0.0 
var _is_timer_active: bool = false
var _touch_start_position: Vector2
var _size: Vector2


func _ready() -> void:
	assert(control and dodge_button and switch_button and reload_button and activity_button)
	self.position = Vector2.ZERO
	_size.x = Global.SCREEN_WIDTH / 2
	_size.y = Global.SCREEN_HEIGHT
	control.custom_minimum_size = Vector2(Global.SCREEN_WIDTH, Global.SCREEN_HEIGHT)
	dodge_button.init_abstract(
			func() -> bool:
				return Global.player.stamina >= Global.player.state_dodge.stamina_cost and not Global.player.get_current_state() is LevelEndPlayerState
	,
			func():
				send_dodge()
	)
	reload_button.init_abstract(
			func() -> bool:
				return not (
						Global.player.weapon.ammo == Global.player.weapon.ammo_max 
						or Global.player.weapon.is_reloading
						or Global.player.get_current_state() is LevelEndPlayerState
				)
	,
			func():
				Global.player.weapon.reload()
	)
	switch_button.init_abstract(
			func() -> bool:
				return not Global.player.get_current_state() is LevelEndPlayerState
	,
			func():
				send_switch()
	)
	activity_button.init_abstract(
			func() -> bool:
				return not Global.player.get_current_state() is LevelEndPlayerState
	,
			func():
				pass
	)
	Global.need_apply_settings.connect(
			func():
				dodge_button.visible = not is_dodge_swipe()
				reload_button.visible = not is_reload_swipe()
				switch_button.visible = not is_switch_swipe()
				activity_button.visible = not is_activity_swipe()
	)


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
					if event.position.y < Global.SCREEN_HEIGHT / 2:
						send_jump_up()
					else:
						send_jump_down()
				elif (is_dodge_swipe() or is_reload_swipe() or is_switch_swipe() or is_activity_swipe()) and _timer <= SWIPE_MAX_TIME:
					var direction := Vector2(event.position - _touch_start_position).normalized()
					if abs(direction.x) + abs(direction.y) < SWIPE_MAX_DIAGONAL_SLOPE:
						if abs(direction.x) > abs(direction.y):
							if direction.x > 0 and is_dodge_swipe():
								send_dodge()
							elif is_switch_swipe():
								send_switch()
						else:
							if direction.y > 0 and is_reload_swipe():
								send_reload()
							elif is_activity_swipe():
								send_activity()
				_timer = 0.0
				_touch_start_position = Vector2.ZERO
	
	elif event is InputEventKey:
		if event.is_action("jump_up"):
			send_jump_up()
		
		elif event.is_action("jump_down"):
			send_jump_down()
		
		elif event.is_action("dodge"):
			send_dodge()
		
		elif event.is_action("activity"):
			send_activity()
		
		elif event.is_action("reload"):
			send_reload()
		
		elif event.is_action("switch_weapon"):
			send_switch()


func send_jump_up():
	tap_up.emit()


func send_jump_down():
	tap_down.emit()


func send_dodge():
	swipe.emit(Vector2.RIGHT)


func send_reload():
	swipe.emit(Vector2.DOWN)


func send_activity():
	swipe.emit(Vector2.UP)


func send_switch():
	swipe.emit(Vector2.LEFT)


func is_dodge_swipe() -> bool:
	return Global.settings[Text.CONTROLS][Text.DODGE_SWIPE]


func is_switch_swipe() -> bool:
	return Global.settings[Text.CONTROLS][Text.SWITCH_WEAPON_SWIPE]


func is_reload_swipe() -> bool:
	return Global.settings[Text.CONTROLS][Text.RELOAD_SWIPE]


func is_activity_swipe() -> bool:
	return Global.settings[Text.CONTROLS][Text.ACTIVITY_SWIPE]
