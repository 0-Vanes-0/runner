class_name SensorButton
extends Control

@export var texture_normal: AtlasTexture
@export var texture_pressed: AtlasTexture
@export var flip_v: bool = false
var is_progressing: bool = false

var is_enabled: Callable
var on_press: Callable
var get_progress_time: Callable

@onready var button := $TouchScreenButton as TouchScreenButton
@onready var progress_bar := $TextureProgressBar as TextureProgressBar


func _ready() -> void:
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
	
	progress_bar.texture_under = texture_pressed
	progress_bar.texture_progress = texture_normal
	progress_bar.scale = Global.SENSOR_BUTTON_SIZE / texture_normal.get_size()
	progress_bar.modulate.a = 0.5
	progress_bar.hide()
	
	self.custom_minimum_size = Global.SENSOR_BUTTON_SIZE
	self.modulate = Color.WHITE
	
	button.pressed.connect(
			func():
				if is_enabled.call() == true:
					on_press.call()
	)

## is_enabled() -> bool, on_press() -> void, get_progress_time() -> float
func new_functions(is_enabled: Callable, on_press: Callable, get_progress_time: Callable = Callable()):
	self.is_enabled = Callable(is_enabled)
	self.on_press = Callable(on_press)
	self.get_progress_time = Callable(get_progress_time)


func _process(delta: float) -> void:
	if button.visible:
		if is_enabled.is_valid() and is_enabled.call() == true:
			self.modulate.a = 1.0
		else:
			self.modulate.a = 0.5


func progress_enabling():
	is_progressing = true
	button.hide()
	progress_bar.show()
	progress_bar.value = progress_bar.min_value
	var progress_time: float = get_progress_time.call() if not get_progress_time.is_null() else 0.0
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
