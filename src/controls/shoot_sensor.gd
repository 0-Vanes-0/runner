class_name ShootSensor
extends VSlider

signal shoot_activated(target_position_y: float)
signal shoot_disabled()

var _LOWEST_Y: float
var _VERT_DISTANCE: float
var _is_shooting: bool
var t: Texture2D


func _ready() -> void:
	_reset_slider()
	self.min_value = 0.0
	self.max_value = 1.0
	_LOWEST_Y = Global.SCREEN_HEIGHT * 1.5
	_VERT_DISTANCE = Global.SCREEN_HEIGHT * 2.0
	
	var image := self.get_theme_icon("grabber").get_image()
	var image_h := self.get_theme_icon("grabber_highlight").get_image()
	var image_d := self.get_theme_icon("grabber_disabled").get_image()
	image.resize(self.size.x * 2, self.size.x * 2, Image.INTERPOLATE_NEAREST)
	image_h.resize(self.size.x * 2, self.size.x * 2, Image.INTERPOLATE_NEAREST)
	image_d.resize(self.size.x * 2, self.size.x * 2, Image.INTERPOLATE_NEAREST)
	image_d.fill(Color.WEB_GRAY)
	var texture := ImageTexture.create_from_image(image)
	var texture_h := ImageTexture.create_from_image(image_h)
	var texture_d := ImageTexture.create_from_image(image_d)
	self.add_theme_icon_override("grabber", texture)
	self.add_theme_icon_override("grabber_highlight", texture_h)
	self.add_theme_icon_override("grabber_disabled", texture_d)


func _physics_process(delta: float) -> void:
	if _is_shooting:
		shoot_activated.emit(_LOWEST_Y - _VERT_DISTANCE * self.value)


func _on_drag_started() -> void:
	_is_shooting = true


func _on_drag_ended(value_changed: bool) -> void:
	_reset_slider()
	shoot_disabled.emit()


func disable(time: float):
	self.editable = false
	await get_tree().create_timer(time, false, true).timeout
	self.editable = true


func _reset_slider():
	_is_shooting = false
	self.value = 0.5
