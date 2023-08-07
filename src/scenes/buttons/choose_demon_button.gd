class_name DemonButton
extends CheckButton

var label: Label


func _ready() -> void:
	label = Global.create_ui_label(24)
	label.size_flags_vertical = Control.SIZE_SHRINK_BEGIN
	$MarginContainer.add_child(label)
