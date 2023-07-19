class_name SensorButton
extends Control

@export var texture_normal: AtlasTexture
@export var texture_pressed: AtlasTexture
var progress_time: float = 0.0
var is_progressing: bool = false

var is_enabled: Callable
var on_press: Callable

@onready var button := $TouchScreenButton as TouchScreenButton
@onready var progress_bar := $TextureProgressBar as TextureProgressBar


func _ready() -> void:
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


func init_abstract(is_enabled: Callable, on_press: Callable):
	self.is_enabled = Callable(is_enabled)
	self.on_press = Callable(on_press)


func _process(delta: float) -> void:
	if button.visible:
		if is_enabled.is_valid() and is_enabled.call() == true:
			self.modulate.a = 1.0
		else:
			self.modulate.a = 0.5


func _physics_process(delta: float) -> void:
	if button.is_pressed():
		if is_enabled.call() == true:
			on_press.call()


func progress_enabling():
	is_progressing = true
	button.hide()
	progress_bar.show()
	progress_bar.value = progress_bar.min_value
	var tween := create_tween()
	tween.tween_property(
			progress_bar,
			"value",
			progress_bar.max_value,
			progress_time
	)
	await tween.finished
	progress_bar.hide()
	button.show()
	is_progressing = false
