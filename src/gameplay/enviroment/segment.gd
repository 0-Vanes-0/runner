class_name Segment
extends Node2D

signal level_about_to_end
signal level_end

var is_last := false
var is_level_about_to_end_emitted := false
var is_level_end_emitted := false
var floors: Array[Node2D] = []


func instantiate_ready():
	self.position.y = Global.SCREEN_HEIGHT
	var platform_h := Platform.SIZE.y
	var gap := Global.FLOORS_GAP

	for i in range(1, Global.MAX_FLOORS + 1):
		var floor_node := Node2D.new()
		floor_node.name = "Floor" + str(i)
		floor_node.position.y = - platform_h - (i-1) * gap
		self.add_child(floor_node)
		floors.append(floor_node)


func clone() -> Segment:
	var segment := self.duplicate() as Segment
	for i in range(1, Global.MAX_FLOORS + 1):
		segment.floors.append(segment.get_node("Floor" + str(i)))
		for j in segment.get_floor(i).get_child_count():
			var orig := self.get_floor(i).get_child(j) as Platform
			var dup := segment.get_floor(i).get_child(j) as Platform
			dup.floor_number = orig.floor_number
			dup.order_number = orig.order_number
	segment.is_last = self.is_last
	return segment


func move(speed: float):
	self.position.x -= speed
	if is_last and not is_level_about_to_end_emitted and self.position.x + get_width() < Global.SCREEN_WIDTH:
		level_about_to_end.emit()
		is_level_about_to_end_emitted = true
	if self.position.x + get_width() < 0:
		if is_last and not is_level_end_emitted:
			level_end.emit()
			is_level_end_emitted = true
		self.queue_free()


func get_floor(number: int) -> Node2D:
	return floors[number - 1]


func set_end_x(x: float):
	$End.position.x = x


func get_width() -> float:
	return $End.position.x


func get_length() -> int:
	return floors[0].get_child_count()


func cut_segment_at(index: int):
	for i in floors.size():
		for platform in floors[i].get_children() as Array[Platform]:
			if platform.order_number >= index:
				platform.queue_free()
				if i == 0:
					set_end_x(minf(get_width(), platform.position.x))
