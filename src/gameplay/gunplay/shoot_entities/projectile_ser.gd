class_name ProjectileSER
extends ShootEntityResource

@export var shape: Shape2D # CircleShape2D or RectangleShape2D
@export_range(1, 30) var size_x_percent: float = 5 # percents of screen_height
@export_range(1, 30) var size_y_percent: float = 5 # percents of screen_height
@export_range(1, 500) var speed_percent: float = 100 # percents of screen_width per second


func get_shape() -> Shape2D:
	if shape != null:
		if shape is CircleShape2D:
			shape.radius = (size_x_percent / 100 * Global.SCREEN_HEIGHT) / 2
			return shape
		elif shape is RectangleShape2D:
			shape.size = Vector2(
					size_x_percent / 100 * Global.SCREEN_HEIGHT
					, size_y_percent / 100 * Global.SCREEN_HEIGHT
			)
			return shape
		else:
			print_debug("shape is not recognized")
			return null
	print_debug("shape is null")
	return null


func get_speed() -> float:
	return speed_percent / 100 * Global.SCREEN_WIDTH
