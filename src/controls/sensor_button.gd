class_name SensorButton
extends Control

@export var texture_normal: AtlasTexture
@export var texture_pressed: AtlasTexture
@export var flip_v: bool = false
var is_progressing: bool = false
var timer := 0.0
const HOLD_TIME := 0.2 # sec

var _is_enabled: Callable
var _on_press: Callable
var _get_progress_time: Callable
var _on_hold: Callable

@onready var button := $TouchScreenButton as TouchScreenButton
@onready var progress_bar := $TextureProgressBar as TextureProgressBar
@onready var icon := $Icon as Sprite2D


func _ready() -> void:
	self._is_enabled = func(): return true
	self._on_press = Callable()
	self._get_progress_time = func(): return 0.0
	self._on_hold = Callable()
	
	if flip_v:
		var image_normal := texture_normal.get_image()
		var image_pressed := texture_pressed.get_image()
		image_normal.flip_y()
		image_pressed.flip_y()
		var flipped_normal := ImageTexture.create_from_image(image_normal)
		var flipped_pressed := ImageTexture.create_from_image(image_pressed)
		button.texture_normal = flipped_normal
		button.texture_pressed = flipped_pressed
	else:
		button.texture_normal = texture_normal
		button.texture_pressed = texture_pressed
	(button.shape as RectangleShape2D).size = texture_normal.get_size()
	button.scale = Global.SENSOR_BUTTON_SIZE / texture_normal.get_size()
	
	icon.position = texture_normal.get_size() / 2
	icon.hide()
	
	progress_bar.texture_under = texture_pressed
	progress_bar.texture_progress = texture_normal
	progress_bar.scale = Global.SENSOR_BUTTON_SIZE / texture_normal.get_size()
	progress_bar.modulate.a = 0.5
	progress_bar.hide()
	
	self.custom_minimum_size = Global.SENSOR_BUTTON_SIZE
	self.modulate = Color.WHITE


func define_on_press(function: Callable):
	self._on_press = Callable(function)


func define_is_enabled(function: Callable):
	self._is_enabled = Callable(function)


func define_get_progress_time(function: Callable):
	self._get_progress_time = Callable(function)


func define_on_hold(function: Callable):
	self._on_hold = Callable(function)


func _physics_process(delta: float) -> void:
	if button.is_pressed():
		assert(not _on_press.is_null() or not _on_hold.is_null(), "_on_press() function was not defined! Use method define_on_press(function: Callable) first!")
		if _is_enabled.call() == true:
			if not _on_hold.is_null():
				timer += delta
				if timer >= HOLD_TIME:
					timer = HOLD_TIME
					_on_hold.call()
				elif not _on_press.is_null():
					_on_press.call()
			else:
				_on_press.call()
	else:
		timer = 0.0


func _process(delta: float) -> void:
	if button.visible:
		if _is_enabled.is_valid() and _is_enabled.call() == true:
			self.modulate.a = 1.0
		else:
			self.modulate.a = 0.5


func progress_enabling():
	is_progressing = true
	button.hide()
	progress_bar.show()
	progress_bar.value = progress_bar.min_value
	var progress_time: float = _get_progress_time.call() if not _get_progress_time.is_null() else 0.0
	var tween := create_tween()
	tween.tween_property(
			progress_bar, "value",
			progress_bar.max_value,
			progress_time
	)
	await tween.finished
	tween.kill()
	progress_bar.hide()
	button.show()
	is_progressing = false


func set_icon(texture: Texture2D):
	icon.texture = texture
	var scale_value: float = (texture_normal.get_size().x / 2) / texture.get_size().x
	icon.scale = Vector2.ONE * scale_value
	icon.show()
