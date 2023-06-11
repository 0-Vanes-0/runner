class_name HealthComponent
extends Area2D

signal out_of_health
signal took_damage

@export_range(1, 9999) var health: int = 100
var shape: CollisionShape2D


func _ready() -> void:
	var child := self.get_child(0)
	if child != null and child is CollisionShape2D:
		shape = child
	assert(shape != null)
	
	Global.clean_layers(self)
	var parent = get_parent()
	if parent != null:
		if parent is Player:
			self.set_collision_layer_value(Global.Layers.PLAYER, true)
			self.set_collision_mask_value(Global.Layers.SHOOT_ENTITY_ENEMY, true)
		elif parent is Enemy:
			self.set_collision_layer_value(Global.Layers.ENEMY, true)
			self.set_collision_mask_value(Global.Layers.SHOOT_ENTITY_PLAYER, true)


func take_damage(damage: int) -> void:
	health = maxi(health - damage, 0)
	took_damage.emit()
	if health == 0:
		out_of_health.emit()


func switch_collision(time: float):
	shape.disabled = true
	await get_tree().create_timer(time).timeout
	shape.disabled = false


func turn_off_collision():
	shape.disabled = true
