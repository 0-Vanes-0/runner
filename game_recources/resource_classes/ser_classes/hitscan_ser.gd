class_name HitscanSER
extends ShootEntityResource

@export var color: Color = Color.WHITE
@export_range(0, 25, 0.1) var beam_width: float # percents of SCREEN_HEIGHT
@export var has_penetration: bool = false


func create_hitscan_shape(start_position := Vector2.ZERO, target_position := Vector2.ONE) -> CollisionShape2D:
	var hitscan_shape := CollisionShape2D.new()
	
	var direction_vector := Vector2(target_position - start_position)
	direction_vector = direction_vector * (Global.SCREEN_WIDTH / direction_vector.length())
	
	if beam_width == 0:
		hitscan_shape.shape = SegmentShape2D.new()
		hitscan_shape.shape.a = start_position
		hitscan_shape.shape.b = start_position + direction_vector
	else:
		hitscan_shape.shape = RectangleShape2D.new()
		hitscan_shape.shape.size.x = Global.SCREEN_WIDTH
		hitscan_shape.shape.size.y = Global.SCREEN_HEIGHT * beam_width / 100
		hitscan_shape.position = start_position + direction_vector / 2
		hitscan_shape.rotation = direction_vector.angle()
		
	return hitscan_shape


func get_beam_width() -> float:
	return Global.SCREEN_HEIGHT * (beam_width / 100.0)
