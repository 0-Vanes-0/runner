class_name Projectile
extends ShootEntity

var area: Area2D
var sprite: Sprite2D
var visibler: VisibleOnScreenNotifier2D

var direction: Vector2
var speed: float


func _init(entity_owner: Object, start_position: Vector2, target_position: Vector2, damage: int, speed: float, texture: Texture2D):
	super(entity_owner, start_position, target_position, damage)
	type = ShootType.PROJECTILE_LINEAR
	self.name = "Projectile"
	self.speed = speed
	
	sprite = Sprite2D.new()
	sprite.texture = texture
	sprite.scale = Vector2(Global.PROJECTILE_SIZE / texture.get_size())
	self.add_child(sprite, true)
	
	area = Area2D.new()
	var collision := CollisionShape2D.new()
	var circle := CircleShape2D.new()
	circle.radius = Global.PROJECTILE_SIZE.x / 2
	collision.shape = circle
	area.add_child(collision, true)
	self.add_child(area, true)
	
	visibler = VisibleOnScreenNotifier2D.new()
	visibler.rect.position = Vector2(- Global.PROJECTILE_SIZE / 2)
	visibler.rect.size = Vector2(Global.PROJECTILE_SIZE)
	visibler.screen_exited.connect(_on_screen_exited)
	self.add_child(visibler, true)


func _ready():
	self.position = start_position
	direction = start_position.direction_to(target_position)


func _process(delta):
	self.position += direction * speed * delta


func _on_screen_exited():
	queue_free()
