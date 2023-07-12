class_name Hitscan
extends ShootEntity

const EXIST_TIME := 0.25
var timer: float
var area: Area2D
var coll_shape: CollisionShape2D


func _init(resource: HitscanSER, entity_owner: ShootEntity.Owner, start_position: Vector2, target_position: Vector2) -> void:
	super(resource, entity_owner, start_position, target_position)
	self.name = "Hitscan"
	
	area = create_collision_object(Area2D.new(), entity_owner)
	coll_shape = resource.create_hitscan_shape(start_position, target_position)
	area.add_child(coll_shape)
	self.add_child(area)
	area.area_entered.connect(
			func(area: Area2D):
				if area is HealthComponent:
					area.take_damage(self.damage)
	)
	
	# Temporal solution:
	var sprite := Sprite2D.new()
	sprite.texture = preload("res://assets/sprites/shoot_entities/arrow.png")
	sprite.centered = false
	sprite.offset = Vector2.DOWN * sprite.texture.get_height() / 2
	sprite.scale = Vector2(
			(target_position - start_position).length() / sprite.texture.get_width(),
			(Global.SCREEN_HEIGHT * (resource.beam_width + 0.1) / 100) / sprite.texture.get_height()
	)
	sprite.rotation = (target_position - start_position).angle()
	sprite.position = start_position
	self.add_child(sprite)
	# Create a better later!!!


func _ready() -> void:
	timer = 0.0


func _physics_process(delta: float) -> void:
	timer += delta
	if timer >= EXIST_TIME:
		self.queue_free()


#var shoot_field := Global.get_game_scene().get_shoot_field()
#func _draw() -> void:
#	coll_shape.shape.draw(coll_shape.get_canvas_item(), color) # CHECK THIS OUT!!!!!
