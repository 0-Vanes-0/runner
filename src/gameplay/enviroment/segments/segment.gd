class_name Segment
extends Node2D


func _ready():
	var height := Global.screen_height
	self.position.y = height
	var platform_h := Platform.SIZE.y
	
	var gap: float = (height - platform_h) / Global.MAX_FLOORS
	$Floor1.position.y = - platform_h
	$Floor2.position.y = - platform_h - 1 * gap
	$Floor3.position.y = - platform_h - 2 * gap
	$Floor4.position.y = - platform_h - 3 * gap


func clone() -> Segment:
	var segment := self.duplicate() as Segment
	for i in range(1, Global.MAX_FLOORS + 1):
		for child in segment.get_floor(i).get_children():
			if child is Platform:
				child.floor_number = i
	return segment


func get_floor(number: int) -> Node2D:
	if number == 1:
		return $Floor1
	if number == 2:
		return $Floor2
	if number == 3:
		return $Floor3
	if number == 4:
		return $Floor4
	return null


func set_end_x(x: float):
	$End.position.x = x


func get_width() -> float:
	return $End.position.x
