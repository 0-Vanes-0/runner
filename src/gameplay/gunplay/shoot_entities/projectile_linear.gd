class_name ProjectileLinear
extends ShootEntity

var sprite: AnimatedSprite2D
var area: Area2D
var visibler: VisibleOnScreenNotifier2D
var speed: float

var _direction: Vector2


func _init(resource: ProjectileSER, entity_owner: Owner, start_position: Vector2, target_position: Vector2):
	super(resource, entity_owner, start_position, target_position)
	self.name = "ProjectileLinear"
	
	self.speed = resource.get_speed()
	
	sprite = AnimatedSprite2D.new()
	sprite.sprite_frames = resource.sprite_frames
	var game_size := Vector2(resource.size_x_percent, resource.size_y_percent) / 100 * Global.screen_height
	sprite.scale = Vector2(game_size / resource.get_sprite_size())
	self.add_child(sprite)
	
	area = Global.clean_layers(Area2D.new())
	if entity_owner == Owner.PLAYER:
		area.set_collision_layer_value(Global.Layers.SHOOT_ENTITY_PLAYER, true)
		area.set_collision_mask_value(Global.Layers.ENEMY, true)
	elif entity_owner == Owner.ENEMY:
		area.set_collision_layer_value(Global.Layers.SHOOT_ENTITY_ENEMY, true)
		area.set_collision_mask_value(Global.Layers.PLAYER, true)
	var collision := CollisionShape2D.new()
	collision.shape = resource.get_shape()
	area.add_child(collision)
	self.add_child(area)
	
	visibler = VisibleOnScreenNotifier2D.new()
	visibler.rect.position = Vector2(- game_size / 2)
	visibler.rect.size = Vector2(game_size)
	visibler.screen_exited.connect(_on_screen_exited)
	self.add_child(visibler)


func _ready():
	self.position = start_position
	_direction = start_position.direction_to(target_position)
	self.rotate(_direction.angle())


func _physics_process(delta):
	self.position += _direction * speed * delta


func _on_screen_exited():
	queue_free()
