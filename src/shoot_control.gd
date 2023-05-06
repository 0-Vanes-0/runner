class_name ShootControl
extends Marker2D

signal tap(position: Vector2)

var _size: Vector2


func _ready():
	self.position = Vector2(Global.screen_width / 2, 0)
	_size.x = Global.screen_width / 2
	_size.y = Global.screen_height
	print_debug("self.position=", self.position, " _size=", _size)


func _process(delta):
	pass


func _input(event):
	if event is InputEventScreenTouch:
		if self.position < event.position and event.position < self.position + _size:
			if event.pressed:
				tap.emit(event.position)
