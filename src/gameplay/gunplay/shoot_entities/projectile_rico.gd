class_name ProjectileRico
extends ShootEntity

const MAX_SPEED := 20000 # Дальше уже совсем много :D

var body: CharacterBody2D
var sprite: AnimatedSprite2D
var speed: float

var _direction: Vector2


func _init(resource: ProjectileSER, entity_owner: ShootEntity.Owner, start_position: Vector2, target_position: Vector2) -> void:
	super(resource, entity_owner, start_position, target_position)
	self.name = "ProjectileRico"
	
	self.speed = resource.get_speed()
	
	body = Global.clean_layers(CharacterBody2D.new()) as CharacterBody2D
	if entity_owner == Owner.PLAYER:
		body.set_collision_layer_value(Global.Layers.SHOOT_ENTITY_PLAYER, true)
		body.set_collision_mask_value(Global.Layers.ENEMY, true)
	elif entity_owner == Owner.ENEMY:
		body.set_collision_layer_value(Global.Layers.SHOOT_ENTITY_ENEMY, true)
		body.set_collision_mask_value(Global.Layers.PLAYER, true)
	body.set_collision_mask_value(Global.Layers.BOUNDS, true)
	var collision := CollisionShape2D.new()
	collision.shape = resource.get_shape()
	body.add_child(collision)
	
	sprite = AnimatedSprite2D.new()
	sprite.sprite_frames = resource.sprite_frames
	var game_size := Vector2(resource.size_x_percent, resource.size_y_percent) / 100 * Global.screen_height
	sprite.scale = Vector2(game_size / resource.get_sprite_size())
	body.add_child(sprite)
	
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
	
	speed += 5.0 if speed < MAX_SPEED else 0
