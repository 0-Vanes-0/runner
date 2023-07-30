class_name ProjectileSER
extends ShootEntityResource

enum ShapeType {
	NONE, CIRCLE, RECTANGLE
}
@export var shape: ShapeType = ShapeType.NONE
@export_range(1, 30) var size_x_percent: float = 5 # percents of screen_height
@export_range(1, 30) var size_y_percent: float = 5 # percents of screen_height
@export_range(1, 500) var speed_percent: float = 100 # percents of screen_width per second


func get_shape() -> Shape2D:
	if shape != ShapeType.NONE:
		if shape == ShapeType.CIRCLE:
			var shape2d := CircleShape2D.new()
			shape2d.radius = (size_x_percent / 100 * Global.SCREEN_HEIGHT) / 2
			return shape2d
		elif shape == ShapeType.RECTANGLE:
			var shape2d := RectangleShape2D.new()
			shape2d.size = Vector2(
					size_x_percent / 100 * Global.SCREEN_HEIGHT
					, size_y_percent / 100 * Global.SCREEN_HEIGHT
			)
			return shape2d
	print_debug("shape has type NONE")
	return null


func get_speed() -> float:
	return speed_percent / 100 * Global.SCREEN_WIDTH
