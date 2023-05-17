class_name Projectile
extends ShootEntity

var sprite: Sprite2D
var area: Area2D

var _direction: Vector2


func _init(entity_owner: Owner, start_position: Vector2, target_position: Vector2, damage: int, texture: Texture2D):
	super(entity_owner, start_position, target_position, damage)
	
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
