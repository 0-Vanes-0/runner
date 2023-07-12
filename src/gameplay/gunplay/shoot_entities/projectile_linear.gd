class_name ProjectileLinear
extends ShootEntity

var sprite: AnimatedSprite2D
var area: Area2D
var visibler: VisibleOnScreenNotifier2D
var speed: float

var _direction: Vector2


func _init(resource: ProjectileSER, entity_owner: ShootEntity.Owner, start_position: Vector2, target_position: Vector2) -> void:
	super(resource, entity_owner, start_position, target_position)
	self.name = "ProjectileLinear"
	
	self.speed = resource.get_speed()
	
	self.add_child( create_animated_sprite(resource) )
	
	area = create_collision_object(Area2D.new(), entity_owner)
	var collision := CollisionShape2D.new()
	collision.shape = resource.get_shape()
	area.add_child(collision)
	self.add_child(area)
	area.area_entered.connect(
			func(area: Area2D):
				if area is HealthComponent and not area.shape.disabled:
					area.take_damage(self.damage)
					self.queue_free()
	)
	
	visibler = VisibleOnScreenNotifier2D.new()
	var game_size := Vector2(resource.size_x_percent, resource.size_y_percent) / 100 * Global.SCREEN_HEIGHT
	visibler.rect.position = Vector2(- game_size / 2)
	visibler.rect.size = Vector2(game_size)
	visibler.screen_exited.connect(self.queue_free)
	self.add_child(visibler)


func _ready() -> void:
	self.position = start_position
	_direction = start_position.direction_to(target_position)
	self.rotate(_direction.angle())


func _physics_process(delta: float) -> void:
	self.position += _direction * speed * delta
