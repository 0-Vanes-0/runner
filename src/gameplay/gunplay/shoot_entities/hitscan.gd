class_name Hitscan
extends ShootEntity

const EXIST_TIME := 0.25
var timer: float
var area: Area2D
var coll_shape: CollisionShape2D
var line2d: Line2D
var has_shot: bool


func _init(resource: HitscanSER, entity_owner: ShootEntity.Owner, start_position: Vector2, target_position: Vector2, damage: int, status_resource: StatusResource = null) -> void:
	super(resource, entity_owner, start_position, target_position, damage, status_resource)
	self.name = "Hitscan"
	
	area = create_collision_object(Area2D.new(), entity_owner)
	coll_shape = resource.create_hitscan_shape(start_position, target_position)
	area.add_child(coll_shape)
	self.add_child(area)
	
	has_shot = false
	area.area_entered.connect(
			func(area: Area2D):
				if area is HealthComponent and not has_shot:
					area.take_damage(self.damage)
					add_status(area.get_parent())
					if not resource.has_penetration:
						has_shot = true
	)
	
	line2d = Line2D.new()
	line2d.default_color = resource.color
	line2d.width = resource.get_beam_width() if resource.beam_width > 0 else 10.0
	line2d.add_point(start_position)
	var direction_vector := Vector2(target_position - start_position)
	direction_vector = direction_vector * (Global.SCREEN_WIDTH / direction_vector.length())
	line2d.add_point(start_position + direction_vector)
	self.add_child(line2d)


func _ready() -> void:
	timer = 0.0
	var tween := create_tween().set_parallel(true)
	tween.tween_property(
			line2d, "modulate:a",
			0.0,
			EXIST_TIME
	)
	tween.tween_property(
			line2d, "width",
			0.0,
			EXIST_TIME
	)


func _physics_process(delta: float) -> void:
	timer += delta
	if timer >= EXIST_TIME:
		self.queue_free()


#var shoot_field := Global.get_game_scene().get_shoot_field()
#func _draw() -> void:
#	coll_shape.shape.draw(coll_shape.get_canvas_item(), color) # CHECK THIS OUT!!!!!
