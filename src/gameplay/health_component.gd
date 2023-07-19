## This is health. Can be attached to any object. Made for [Player] and [Enemy].
class_name HealthComponent
extends Area2D

signal out_of_health ## Called when health is 0.
signal switched_collision ## Called when stopped shape's disabling.

@export_range(1, 9999) var health: int = 100
@export var _shape: CollisionShape2D
var label: Label


func _ready() -> void:
	assert(_shape)
	
	Global.clean_layers(self)
	var parent = get_parent()
	assert(parent != null and (parent is Player or parent is Enemy))
	if parent is Player:
		self.set_collision_layer_value(Global.Layers.PLAYER, true)
		self.set_collision_mask_value(Global.Layers.SHOOT_ENTITY_ENEMY, true)
	elif parent is Enemy:
		self.set_collision_layer_value(Global.Layers.ENEMY, true)
		self.set_collision_mask_value(Global.Layers.SHOOT_ENTITY_PLAYER, true)
	
	label = Label.new()
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.set_position(self.position)
	label.add_theme_font_size_override("font_size", 24)
	self.add_child(label)
	label.text = str(health)

## Substracts [member health] by [param damage] and animates sprite of parent, if exists. 
func take_damage(damage: int) -> void:
	health = maxi(health - damage, 0)
	if health == 0:
		out_of_health.emit()
	label.text = str(health)
	
	if get_parent().sprite != null:
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

## Turns off collision for [param time].
func switch_collision(time: float):
	turn_off_collision()
	await get_tree().create_timer(time).timeout
	turn_on_collision()
	switched_collision.emit()


func turn_off_collision():
	_shape.disabled = true


func turn_on_collision():
	_shape.disabled = false


func is_shape_enabled() -> bool:
	return not _shape.disabled
