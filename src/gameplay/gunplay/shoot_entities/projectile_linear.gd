class_name ProjectileLinear
extends Projectile

var visibler: VisibleOnScreenNotifier2D
var speed: float


func _init(entity_owner: Owner, start_position: Vector2, target_position: Vector2, damage: int, texture: Texture2D, speed: float):
	super(entity_owner, start_position, target_position, damage, texture)
	self.name = "ProjectileLinear"
	
	self.speed = speed
	
	visibler = VisibleOnScreenNotifier2D.new()
	visibler.rect.position = Vector2(- Global.PROJECTILE_SIZE / 2)
	visibler.rect.size = Vector2(Global.PROJECTILE_SIZE)
	visibler.screen_exited.connect(_on_screen_exited)
	self.add_child(visibler, true)


func _ready():
	self.position = start_position
	_direction = start_position.direction_to(target_position)


func _process(delta):
	self.position += _direction * speed * delta


func _on_screen_exited():
	queue_free()
