class_name SnappedProgressBar
extends ProgressBar

@export_range(0, 999) var snap_step: int = 10
@export var snap_color: Color = Color.BLACK
var snap_width: int = roundi(Global.SCREEN_HEIGHT * 0.004)

@onready var v_box := $VBoxContainer as VBoxContainer
@onready var empty_color_rect := $VBoxContainer/EmptyColorRect as ColorRect
var snaps: Array[ColorRect] = []


func set_max_value(max_value: int, snap_step: int = 0):
	self.min_value = 0
	self.max_value = max_value
	if snap_step > 0:
		self.snap_step = snap_step
	self.snap_step = clampi(self.snap_step, int(self.min_value), int(self.max_value))
	
	resized.emit()
	
	for child in snaps:
		child.queue_free()
	snaps.clear()
	
	var snaps_count: int
	if max_value % self.snap_step == 0:
		snaps_count = max_value / self.snap_step - 1
	else:
		snaps_count = max_value / self.snap_step
	
	empty_color_rect.custom_minimum_size.y = float(snap_width) / 2
	
	for i in snaps_count:
		var color_rect := ColorRect.new()
		color_rect.name = "Snap" + str(i)
		color_rect.color = snap_color
		color_rect.custom_minimum_size.y = snap_width
		v_box.add_child(color_rect)
		v_box.move_child(color_rect, 0)
		snaps.append(color_rect)


func _on_resized() -> void:
	var bar_length := self.size.y
	v_box.add_theme_constant_override(
			"separation",
			roundi( bar_length * (float(snap_step) / float(self.max_value)) - snap_width )
	)
