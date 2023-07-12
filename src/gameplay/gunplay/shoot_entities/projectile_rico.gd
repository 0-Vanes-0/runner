class_name ProjectileRico
extends ShootEntity

const MAX_SPEED := 20000 # Дальше уже совсем много :D

var body: CharacterBody2D
var sprite: AnimatedSprite2D
var speed: float

var _direction: Vector2


func _init(resource: ProjectileSER, entity_owner: ShootEntity.Owner, start_position: Vector2, target_position: Vector2, damage: int) -> void:
	super(resource, entity_owner, start_position, target_position, damage)
	self.name = "ProjectileRico"
	
	self.speed = resource.get_speed()
	
	body = create_collision_object(CharacterBody2D.new(), entity_owner)
	body.add_child( create_animated_sprite(resource) )
	self.add_child(body)


func _ready() -> void:
	body.position = start_position
	_direction = start_position.direction_to(target_position)


func _physics_process(delta: float) -> void:
	var collision: KinematicCollision2D = body.move_and_collide(_direction * speed * delta)
	if collision:
		var motion = collision.get_remainder().bounce(collision.get_normal())
		_direction = _direction.bounce(collision.get_normal())
		body.move_and_collide(motion)
	
	speed += 5.0 if speed < MAX_SPEED else 0.0
