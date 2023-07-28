class_name Platform
extends StaticBody2D

static var SIZE: Vector2
var order_number: int = 0
var floor_number: int = 0


func _ready() -> void:
	assert(SIZE != Vector2.ZERO)
	self.scale = SIZE / $CollisionShape2D.shape.size
	
	Global.clean_layers(self).set_collision_layer_value(Global.Layers.PLATFORM, true)
	self.collision_mask = Global.Layers.PLAYER


func _on_visibler_exited() -> void:
	if floor_number == 1:
		Global.player.platforms_left -= 1
