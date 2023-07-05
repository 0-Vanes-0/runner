class_name HealthComponent
extends Area2D

signal out_of_health
signal switched_collision

@export_range(1, 9999) var health: int = 100
var shape: CollisionShape2D


func _ready() -> void:
	var child := self.get_child(0)
	if child != null and child is CollisionShape2D:
		shape = child
	assert(shape != null)
	
	Global.clean_layers(self)
	var parent = get_parent()
	assert(parent != null and (parent is Player or parent is Enemy))
	if parent is Player:
		self.set_collision_layer_value(Global.Layers.PLAYER, true)
		self.set_collision_mask_value(Global.Layers.SHOOT_ENTITY_ENEMY, true)
	elif parent is Enemy:
		self.set_collision_layer_value(Global.Layers.ENEMY, true)
		self.set_collision_mask_value(Global.Layers.SHOOT_ENTITY_PLAYER, true)


func take_damage(damage: int) -> void:
	assert(get_parent().sprite != null)
	var orig_modulate: Color = get_parent().sprite.modulate
	var tween := create_tween()
	tween.tween_property(
			get_parent().sprite,
			"modulate",
			orig_modulate.inverted(), # todo: make better here
			0.0
	)
	tween.tween_interval(0.2)
	tween.tween_property(
			get_parent().sprite,
			"modulate",
			orig_modulate,
			0.0
	)
	health = maxi(health - damage, 0)
	if health == 0:
		out_of_health.emit()
	


func switch_collision(time: float):
	turn_off_collision()
	await get_tree().create_timer(time).timeout
	turn_on_collision()
	switched_collision.emit()


func turn_off_collision():
	shape.disabled = true


func turn_on_collision():
	shape.disabled = false
