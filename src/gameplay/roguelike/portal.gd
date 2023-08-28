class_name Portal
extends Area2D

signal portal_chosen(reward: Reward)

var reward: Reward
@export var sprite: AnimatedSprite2D
@export var coll_shape: CollisionShape2D

const PORTAL_COLORS := {
	Reward.DEMON_PASSIVITY: Color.HOT_PINK,
	Reward.WEAPON_PASSIVITY: Color.WHITE,
	Reward.SHOOT_ENTITY_STATUS: Color.WHITE,
	Reward.WEAPON: Color.WHITE,
	Reward.ACTIVITY: Color.WHITE,
}
const PORTAL_ANIMATIONS := {
	Reward.DEMON_PASSIVITY: "passivity",
	Reward.WEAPON_PASSIVITY: "passivity",
	Reward.SHOOT_ENTITY_STATUS: "passivity",
	Reward.WEAPON: "weactivity",
	Reward.ACTIVITY: "weactivity",
}


func set_reward(reward: Reward):
	self.reward = reward


func _ready() -> void:
	assert(sprite and coll_shape)
	assert(reward != null)
	
	self.scale = Vector2.ZERO
	
	Global.clean_layers(self).set_collision_layer_value(Global.Layers.BOUNDS, true)
	
	var label := Global.create_ui_label(24)
	label.modulate.a = 0.0
	if reward.get_type() == Reward.DEMON_PASSIVITY:
		var res := reward.get_as_demon_passivity_res()
		label.text = res.Types.keys()[ res.Types.values().find(res.type) ] + " +" + str(res.value) + "%"
	elif reward.get_type() == Reward.WEAPON:
		label.text = "WEAPON"
	self.add_child(label)
	
	sprite.modulate = PORTAL_COLORS[reward.get_type()]
	sprite.play(PORTAL_ANIMATIONS[reward.get_type()])
	
	var tween := create_tween()
	tween.tween_property(
			self, "scale",
			Global.player.get_game_size() * 2 / (coll_shape.shape as RectangleShape2D).size,
			1.0
	).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.tween_callback(
			func():
				label.set_scale(Vector2(1/self.scale.x, 1/self.scale.y))
				label.position = Vector2(
						- label.get_minimum_size().x / 2,
						- (coll_shape.shape as RectangleShape2D).size.y
				) * label.scale
	)
	tween.tween_property(
			label, "modulate:a",
			1.0,
			1.0
	)


func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int):
	if event is InputEventScreenTouch and event.pressed:
		portal_chosen.emit(reward)
