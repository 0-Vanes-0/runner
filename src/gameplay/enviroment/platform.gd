class_name Platform
extends StaticBody2D

var size := Vector2.ZERO

func _ready():
	var texture_size: Vector2 = $Sprite2D.texture.get_size()
	var scale: Vector2 = $Sprite2D.scale
	size = Vector2(texture_size * scale)


func _process(delta):
	pass
