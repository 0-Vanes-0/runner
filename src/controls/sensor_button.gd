class_name SensorButton
extends Control

@export var texture_normal: AtlasTexture
@export var texture_pressed: AtlasTexture

var is_enabled: Callable
var on_press: Callable

@onready var button := $TouchScreenButton as TouchScreenButton


func _ready() -> void:
	self.custom_minimum_size = Global.SENSOR_BUTTON_SIZE
	button.texture_normal = texture_normal
	button.texture_pressed = texture_pressed
	(button.shape as RectangleShape2D).size = texture_normal.get_size()
	button.scale = Global.SENSOR_BUTTON_SIZE / texture_normal.get_size()
	self.modulate = Color.WHITE


func init_abstract(is_enabled: Callable, on_press: Callable):
	self.is_enabled = Callable(is_enabled)
	self.on_press = Callable(on_press)


func _process(delta: float) -> void:
	if is_enabled.is_valid() and is_enabled.call() == true:
		self.modulate.a = 1.0
	else:
		self.modulate.a = 0.5


func _on_touch_screen_button_pressed() -> void:
	if is_enabled.call() == true:
		on_press.call()


func _on_touch_screen_button_released() -> void:
	pass # Replace with function body.
