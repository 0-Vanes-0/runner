class_name ShootSensor
extends Marker2D

signal tap(position: Vector2)

var _size: Vector2


func _ready():
	self.position = Vector2(Global.screen_width / 2, 0)
	_size.x = Global.screen_width / 2
	_size.y = Global.screen_height


func _unhandled_input(event):
	if event is InputEventScreenTouch:
		if self.position < event.position and event.position < self.position + _size:
			if event.pressed:
				tap.emit(event.position)
