class_name Platform
extends StaticBody2D

const SIZE := Vector2(480, 40)
var order_number: int = 0
var floor_number: int = 0


func _ready() -> void:
	self.scale = SIZE / $CollisionShape2D.shape.size
	
	Global.clean_layers(self).set_collision_layer_value(Global.Layers.PLATFORM, true)
	self.collision_mask = Global.Layers.PLAYER


func _on_visibler_exited() -> void:
	if floor_number == 1:
		Global.player.platforms_left -= 1
