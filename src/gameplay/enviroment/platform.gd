class_name Platform
extends StaticBody2D

const SIZE := Vector2(480, 40)
var floor_number: int = 0


func _ready():
	var texture_size: Vector2 = $Sprite2D.texture.get_size()
	$Sprite2D.scale = Vector2(SIZE / texture_size)
	Global.clean_layers(self).set_collision_layer_value(Global.Layers.PLATFORM, true)
	self.collision_mask = Global.Layers.PLAYER
	$VisibleOnScreenEnabler2D.rect = Rect2(
		self.position.x, 
		self.position.y,
		SIZE.x,
		SIZE.y
	)


func set_one_way(value: bool):
	$CollisionShape2D.one_way_collision = value


func toggle_collision():
	$CollisionShape2D.disabled = true
	await get_tree().create_timer(0.1).timeout
	$CollisionShape2D.disabled = false
