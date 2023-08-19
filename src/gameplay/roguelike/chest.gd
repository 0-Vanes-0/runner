class_name Chest
extends Area2D

signal clicked

@export var sprite: AnimatedSprite2D
@export var coll_chape: CollisionShape2D
var reward: Reward
var _label: Label
var is_shown := false


func _ready() -> void:
	assert(sprite)
	self.scale = Vector2.ONE * Global.player.get_game_size().y / (coll_chape.shape as RectangleShape2D).size.y
	
	_label = Global.create_ui_label(24)
	_label.modulate.a = 0.0
	if reward.get_type() == Reward.DEMON_PASSIVITY:
		var res := reward.get_as_demon_passivity_res()
		_label.text = res.Types.keys()[ res.Types.values().find(res.type) ] + " +" + str(res.value) + "%"
	_label.set_scale(Vector2(1/self.scale.x, 1/self.scale.y))
	_label.position = Vector2.LEFT * _label.get_minimum_size().x * _label.scale.x
	self.add_child(_label)
	
	var tween := create_tween()
	tween.tween_property(
			sprite, "modulate:a",
			1.0,
			1.0
	).from(0.0)
	tween.tween_property(
			self, "is_shown",
			true,
			0.0
	)


func open():
	sprite.play("open")
	await sprite.animation_finished
	var tween := create_tween()
	tween.tween_property(
			_label, "modulate:a",
			1.0,
			0.0
	)
	tween.tween_property(
			_label, "position:y",
			- Global.player.get_game_size().y / 4,
			1.0
	)
	tween.tween_property(
			_label, "modulate:a",
			0.0,
			1.0
	)
	tween.tween_callback(
			func():
				clicked.emit()
	)


func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventScreenTouch and event.pressed:
		if is_shown:
			open()
