## This class reads all actions from player.
class_name PlayerSensor
extends Control

signal dodge
signal reload
signal activity
signal switch
signal jump_up ## Signal for tapping at top half of screen.
signal jump_down ## Signal for tapping at bottom half of screen.

const SWIPE_MAX_DIAGONAL_SLOPE := 1.35 ## This constant is a limit of diagonal swipe. Totally diagonal swipe has value 1.44 as sqrt(2). This constant can be changed but 1.35 is best as tested.
const TAP_MAX_VECTOR := Vector2.ONE * 10 ## Tap gesture can have a bit more than Vector2(0, 0), and for that reason this constant exists.

@export var activity_button: SensorButton
@export var switch_button: SensorButton
@export var dodge_button: SensorButton
@export var jump_up_button: SensorButton
@export var jump_down_button: SensorButton
@export var switch_weapon_disabled_time: float # REMOVE LATER


func _ready() -> void:
	assert(dodge_button and switch_button and activity_button and jump_up_button and jump_down_button)
	dodge_button.init_functions(
			func() -> bool:
				var player := Global.player as Player
				return player.stamina >= DodgePlayerState.STAMINA_COST and not player.get_current_state() is LevelEndPlayerState
	,
			func():
				send_dodge()
	)
	switch_button.progress_time = switch_weapon_disabled_time
	switch_button.init_functions(
			func() -> bool:
				var player := Global.player as Player
				return not (
						player.get_current_state() is LevelEndPlayerState 
						or player.weapon2 == null
						or switch_button.is_progressing
				)
	,
			func():
				send_switch()
	)
	activity_button.init_functions(
			func() -> bool:
				var player := Global.player as Player
				return not (
						player.get_current_state() is LevelEndPlayerState 
						or player.activity == null
						or player.activity.is_reloading()
						or activity_button.is_progressing
				)
	,
			func():
				send_activity()
	)
	jump_down_button.init_functions(
			func() -> bool:
				var player := Global.player as Player
				return player.stamina >= JumpDownPlayerState.STAMINA_COST and not player.get_current_state() is LevelEndPlayerState
	,
			func():
				send_jump_down()
	)
	jump_up_button.init_functions(
			func() -> bool:
				var player := Global.player as Player
				return player.stamina >= JumpUpPlayerState.STAMINA_COST and not player.get_current_state() is LevelEndPlayerState
	,
			func():
				send_jump_up()
	)


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.is_pressed():
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
	
#	if event is InputEventScreenTouch:
#		if self.position < event.position and event.position < self.position + _size:
#			if event.pressed:
#				_touch_start_position = event.position
#			else:
#				var vector: Vector2 = abs(event.position - _touch_start_position)
#				if vector.length_squared() <= TAP_MAX_VECTOR.length_squared():
#					if event.position.y < Global.SCREEN_HEIGHT / 2:
#						send_jump_up()
#					else:
#						send_jump_down()
#				elif (_is_dodge_swipe_active() or _is_reload_swipe_active() or _is_switch_swipe_active() or _is_activity_swipe_active()):
#					var direction := Vector2(event.position - _touch_start_position).normalized()
#					if abs(direction.x) + abs(direction.y) < SWIPE_MAX_DIAGONAL_SLOPE:
#						if abs(direction.x) > abs(direction.y):
#							if direction.x > 0 and _is_dodge_swipe_active():
#								send_dodge() # swipe right
#							elif direction.x < 0 and _is_switch_swipe_active():
#								send_switch() # swipe left
#						else:
#							if direction.y > 0 and _is_reload_swipe_active():
#								send_reload() # swipe down
#							elif direction.y < 0 and _is_activity_swipe_active():
#								send_activity() # swipe up
#				_touch_start_position = Vector2.ZERO


func update_activity_button_progress_time():
	var player := Global.player as Player
	activity_button.progress_time = player.activity.reload_time


func send_jump_up():
	jump_up.emit()


func send_jump_down():
	jump_down.emit()


func send_dodge():
	dodge.emit()


func send_reload():
	reload.emit()


func send_activity():
	update_activity_button_progress_time()
	var player := Global.player as Player
	if not activity_button.is_progressing and player.activity != null:
		activity.emit()
		activity_button.progress_enabling()


func send_switch():
	var player := Global.player as Player
	if not switch_button.is_progressing and player.weapon1 != null and player.weapon2 != null:
		switch.emit()
		switch_button.progress_enabling()
