class_name Segment
extends Node2D

signal level_about_to_end
signal level_end

var is_last := false
var is_level_about_to_end_emitted := false
var is_level_end_emitted := false


func _ready() -> void:
	self.position.y = Global.screen_height
	var platform_h := Global.PLATFORM_H
	var gap := Global.FLOORS_GAP
	
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
	segment.is_last = self.is_last
	return segment


func move(speed: float):
	self.position.x -= speed
	if is_last and not is_level_about_to_end_emitted and self.position.x + get_width() < Global.screen_width:
		level_about_to_end.emit()
		is_level_about_to_end_emitted = true
	if self.position.x + get_width() < 0:
		if is_last and not is_level_end_emitted:
			level_end.emit()
			is_level_end_emitted = true
		self.queue_free()


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
