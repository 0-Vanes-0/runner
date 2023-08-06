class_name StatusHandler
extends Node2D

var _label: Label


func _ready() -> void:
	var parent = get_parent()
	assert(parent != null and (parent is Player or parent is Enemy))
	_label = Global.create_ui_label(24)
	self.add_child(_label)
	var scale = parent.get_adjust_scale()
	_label.set_scale(Vector2(1/scale.y, 1/scale.y))


func add_status(new_status_resource: StatusResource):
	var counter := 0
	for status in get_statuses():
		if status.tag == new_status_resource.tag:
			counter += 1
	if counter < new_status_resource.status_count_max:
		var status := Status.new(new_status_resource)
		self.add_child(status)
		status.deleted.connect(_update_label)
		_update_label()


func get_statuses() -> Array[Status]:
	var array: Array[Status] = []
	for child in self.get_children():
		if child is Status:
			array.append(child)
	return array


func clear_statuses():
	for status in get_statuses():
		status.delete_status()


func _update_label():
	var tags: Array = StatusResource.Tags.values()
	var counters := {}
	for tag in tags:
		counters[tag] = 0
	
	for status in get_statuses():
		counters[status.tag] += 1
	
	_label.text = ""
	for key in counters.keys():
		if counters[key] > 0:
			_label.text += str(counters[key]) + " " + str(StatusResource.Tags.keys()[key]) + "\n"
