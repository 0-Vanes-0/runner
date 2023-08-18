class_name Chest
extends Node2D

@export var sprite: AnimatedSprite2D
var reward: Reward


func _ready() -> void:
	assert(sprite)


func open():
	sprite.play("open")
