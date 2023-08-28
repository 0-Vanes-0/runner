class_name RewardMenu
extends Control

signal choosed
signal need_kill_tween

@export var _card1: PanelContainer
@export var _card2: PanelContainer
@export var _card3: PanelContainer
@export var _texture_rect1: TextureRect
@export var _texture_rect2: TextureRect
@export var _texture_rect3: TextureRect
@export var _label1: RichTextLabel
@export var _label2: RichTextLabel
@export var _label3: RichTextLabel
@export var _button1: Button
@export var _button2: Button
@export var _button3: Button


func _ready() -> void:
	assert(_card1 and _card2 and _card3 and _texture_rect1 and _texture_rect2 and _texture_rect3 and _label1 and _label2 and _label3 and _button1 and _button2 and _button3)
	self.hide()
	_card1.hide()
	_card2.hide()
	_card3.hide()


func show_weapons(with_reward: Reward):
	assert(with_reward.get_type() == Reward.WEAPON)
	var player := Global.player as Player
	
	_texture_rect1.texture = player.weapon1.get_preview()
	_label1.text = player.weapon1.get_description()
	_button1.pressed.connect(
			func():
				choosed.emit()
				player.weapon1.queue_free()
				player.weapon1 = Weapon.new(with_reward.get_as_weapon_res(), with_reward.get_rarity(), ShootEntity.Owner.PLAYER)
				player.activate_weapon1()
				player.weapon_marker.add_child(player.weapon1)
				GameInfo.current_reward = null
				hide_all()
	)
	_button1.text = "Replace"
	_card1.show()
	
	if player.weapon2 != null:
		_texture_rect2.texture = player.weapon2.get_preview()
		_label2.text = player.weapon2.get_description()
		_button2.pressed.connect(
				func():
					choosed.emit()
					player.weapon2.queue_free()
					player.weapon2 = Weapon.new(with_reward.get_as_weapon_res(), with_reward.get_rarity(), ShootEntity.Owner.PLAYER)
					player.activate_weapon2()
					player.weapon_marker.add_child(player.weapon2)
					GameInfo.current_reward = null
					hide_all()
		)
		_button2.text = "Replace"
		_card2.show()
		
		_button3.pressed.connect(
				func():
					choosed.emit()
					# Add exp?
					GameInfo.current_reward = null
					hide_all()
		)
		_button3.text = "Consume"
	
	else:
		_button3.pressed.connect(
				func():
					choosed.emit()
					player.weapon2 = Weapon.new(with_reward.get_as_weapon_res(), with_reward.get_rarity(), ShootEntity.Owner.PLAYER)
					player.activate_weapon2()
					player.weapon_marker.add_child(player.weapon2)
					GameInfo.current_reward = null
					hide_all()
		)
		_button3.text = "Take"
	
	_texture_rect3.texture = with_reward.get_as_weapon_res().get_preview()
	_label3.text = with_reward.get_as_weapon_res().get_description(with_reward.get_rarity(), true)
	_card3.show()
	
	play_intro()


func show_activities(with_reward: Reward):
	assert(with_reward.get_type() == Reward.ACTIVITY)
	var player := Global.player as Player
	
	self.show()


func play_intro():
	self.position.y = Global.SCREEN_HEIGHT
	self.show()
	var tween := create_tween()
	tween.tween_property(
			self, "position:y",
			0,
			1.0
	).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	need_kill_tween.connect(
			func():
				tween.kill()
	)


func hide_all():
	need_kill_tween.emit()
	var tween := create_tween()
	tween.tween_property(
			self, "position:y",
			- Global.SCREEN_HEIGHT,
			1.0
	).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN)
	tween.tween_callback(
			func():
				for dict in _button1.pressed.get_connections() as Array[Dictionary]:
					_button1.pressed.disconnect(dict["callable"])
				for dict in _button2.pressed.get_connections() as Array[Dictionary]:
					_button2.pressed.disconnect(dict["callable"])
				for dict in _button3.pressed.get_connections() as Array[Dictionary]:
					_button3.pressed.disconnect(dict["callable"])
				
				_card1.hide()
				_card2.hide()
				_card3.hide()
				
				self.hide()
	)
	tween.finished.connect(tween.kill, CONNECT_ONE_SHOT)
