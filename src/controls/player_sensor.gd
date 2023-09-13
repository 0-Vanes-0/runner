## This class reads all actions from player.
class_name PlayerSensor
extends Marker2D

signal dodge
signal reload
signal activity
signal switch
signal tap_up ## Signal for tapping at top half of screen.
signal tap_down ## Signal for tapping at bottom half of screen.

const SWIPE_MAX_DIAGONAL_SLOPE := 1.35 ## This constant is a limit of diagonal swipe. Totally diagonal swipe has value 1.44 as sqrt(2). This constant can be changed but 1.35 is best as tested.
const TAP_MAX_VECTOR := Vector2.ONE * 10 ## Tap gesture can have a bit more than Vector2(0, 0), and for that reason this constant exists.

@export var control: Control
@export var dodge_button: SensorButton
@export var reload_button: SensorButton
@export var switch_button: SensorButton
@export var activity_button: SensorButton
@export var switch_weapon_disabled_time: float

var _touch_start_position: Vector2
var _size: Vector2


func _ready() -> void:
	assert(control and dodge_button and switch_button and reload_button and activity_button)
	self.position = Vector2.ZERO
	_size.x = Global.SCREEN_WIDTH / 2
	_size.y = Global.SCREEN_HEIGHT
	control.custom_minimum_size = Vector2(Global.SCREEN_WIDTH, Global.SCREEN_HEIGHT)
	control.show()
	dodge_button.init_abstract(
			func() -> bool:
				var player := Global.player as Player
				return player.stamina >= DodgePlayerState.STAMINA_COST and not player.get_current_state() is LevelEndPlayerState
	,
			func():
				send_dodge()
	)
	reload_button.init_abstract(
			func() -> bool:
				var player := Global.player as Player
				return not (
						player.weapon.ammo == player.weapon.ammo_max 
						or player.weapon.is_reloading
						or player.get_current_state() is LevelEndPlayerState
						or player.weapon.ammo_max == 1
				)
	,
			func():
				var player := Global.player as Player
				player.weapon.reload()
	)
	switch_button.progress_time = switch_weapon_disabled_time
	switch_button.init_abstract(
			func() -> bool:
				var player := Global.player as Player
				return not (
						player.get_current_state() is LevelEndPlayerState 
						or switch_button.is_progressing
				)
	,
			func():
				send_switch()
	)
	activity_button.init_abstract(
			func() -> bool:
				var player := Global.player as Player
				return not (
						player.get_current_state() is LevelEndPlayerState 
						or player.activity.is_reloading()
				)
	,
			func():
				send_activity()
	)
	Global.need_apply_settings.connect(
			func():
				dodge_button.visible = not _is_dodge_swipe_active()
				reload_button.visible = not _is_reload_swipe_active()
				switch_button.visible = not _is_switch_swipe_active()
				activity_button.visible = not _is_activity_swipe_active()
	)


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventScreenTouch:
		if self.position < event.position and event.position < self.position + _size:
			if event.pressed:
				_touch_start_position = event.position
			else:
				var vector: Vector2 = abs(event.position - _touch_start_position)
				if vector.length_squared() <= TAP_MAX_VECTOR.length_squared():
					if event.position.y < Global.SCREEN_HEIGHT / 2:
						send_jump_up()
					else:
						send_jump_down()
				elif (_is_dodge_swipe_active() or _is_reload_swipe_active() or _is_switch_swipe_active() or _is_activity_swipe_active()):
					var direction := Vector2(event.position - _touch_start_position).normalized()
					if abs(direction.x) + abs(direction.y) < SWIPE_MAX_DIAGONAL_SLOPE:
						if abs(direction.x) > abs(direction.y):
							if direction.x > 0 and _is_dodge_swipe_active():
								send_dodge() # swipe right
							elif direction.x < 0 and _is_switch_swipe_active():
								send_switch() # swipe left
						else:
							if direction.y > 0 and _is_reload_swipe_active():
								send_reload() # swipe down
							elif direction.y < 0 and _is_activity_swipe_active():
								send_activity() # swipe up
				_touch_start_position = Vector2.ZERO
	
	elif event is InputEventKey and event.is_pressed():
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


func update_activity_button_progress_time():
	var player := Global.player as Player
	activity_button.progress_time = player.activity.reload_time


func send_jump_up():
	tap_up.emit()


func send_jump_down():
	tap_down.emit()


func send_dodge():
	dodge.emit()


func send_reload():
	reload.emit()


func send_activity():
	activity.emit()


func send_switch():
	if not switch_button.is_progressing:
		switch.emit()
		switch_button.progress_enabling()


func _is_dodge_swipe_active() -> bool:
	return Global.settings[Text.CONTROLS][Text.DODGE_SWIPE]


func _is_switch_swipe_active() -> bool:
	return Global.settings[Text.CONTROLS][Text.SWITCH_WEAPON_SWIPE]


func _is_reload_swipe_active() -> bool:
	return Global.settings[Text.CONTROLS][Text.RELOAD_SWIPE]


func _is_activity_swipe_active() -> bool:
	return Global.settings[Text.CONTROLS][Text.ACTIVITY_SWIPE]
