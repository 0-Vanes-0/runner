class_name RewardMenu
extends Control

signal choosed
signal need_kill_tween

enum Cards {
	REPLACE_1,
	REPLACE_2,
	TAKE_OR_CONSUME_3,
}

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


func show_weapons():
	assert(GameInfo.current_reward.get_type() == Reward.WEAPON)
	
	var player := Global.player as Player
	var reward := GameInfo.current_reward as Reward
	_fill_card(
			Cards.REPLACE_1, 
			player.weapon1.get_preview(), 
			player.weapon1.get_description()
	)
	if player.weapon2 != null:
		_fill_card(
				Cards.REPLACE_2, 
				player.weapon2.get_preview(), 
				player.weapon2.get_description()
		)
	_fill_card(
		Cards.TAKE_OR_CONSUME_3, 
		reward.get_as_weapon_res().get_preview(), 
		reward.get_as_weapon_res().get_description(reward.get_rarity(), true)
	)
	
	_play_intro()


func show_activities():
	assert(GameInfo.current_reward.get_type() == Reward.ACTIVITY)
	
	var player := Global.player as Player
	var reward := GameInfo.current_reward as Reward
	if player.activity != null:
		_fill_card(
				Cards.REPLACE_1, 
				player.activity.get_preview(), 
				player.activity.get_description()
		)
	_fill_card(
		Cards.TAKE_OR_CONSUME_3, 
		reward.get_as_activity_res().get_preview(), 
		reward.get_as_activity_res().get_description(reward.get_rarity(), true)
	)
	
	_play_intro()


func _play_intro():
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


func _fill_card(card_number: Cards, texture: Texture2D, text: String):
	var card: PanelContainer = (
			_card1 if card_number == Cards.REPLACE_1
			else _card2 if card_number == Cards.REPLACE_2
			else _card3 if card_number == Cards.TAKE_OR_CONSUME_3
			else null
	)
	var texture_rect: TextureRect = (
			_texture_rect1 if card_number == Cards.REPLACE_1
			else _texture_rect2 if card_number == Cards.REPLACE_2
			else _texture_rect3 if card_number == Cards.TAKE_OR_CONSUME_3
			else null
	)
	var label: RichTextLabel = (
			_label1 if card_number == Cards.REPLACE_1
			else _label2 if card_number == Cards.REPLACE_2
			else _label3 if card_number == Cards.TAKE_OR_CONSUME_3
			else null
	)
	var button: Button = (
			_button1 if card_number == Cards.REPLACE_1
			else _button2 if card_number == Cards.REPLACE_2
			else _button3 if card_number == Cards.TAKE_OR_CONSUME_3
			else null
	)
	assert(card and texture_rect and label and button)
	
	texture_rect.texture = texture
	label.text = text
	
	var player := Global.player as Player
	var type: int = GameInfo.current_reward.get_type()
	
	if type == Reward.WEAPON or type == Reward.ACTIVITY:
		
		if card_number == Cards.REPLACE_1 or card_number == Cards.REPLACE_2:
			button.text = "Replace"
			button.pressed.connect(
					func():
						_apply_reward_and_hide(card_number)
			)
		elif (
				type == Reward.WEAPON and player.weapon2 == null
				or 
				type == Reward.ACTIVITY and player.activity == null
		):
			button.text = "Take"
			button.pressed.connect(
					func():
						_apply_reward_and_hide(Cards.TAKE_OR_CONSUME_3)
			)
		else:
			button.text = "Consume"
			button.pressed.connect(
					func():
						GameInfo.experience += 100 # WIP !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
						choosed.emit()
						hide_all()
			)
	
	else:
		
		button.text = "Take"
		button.pressed.connect(
				func():
					_apply_reward_and_hide(card_number)
		)
	
	card.show()


func _apply_reward_and_hide(card_number: Cards):
	var player := Global.player as Player
	choosed.emit()
	var type: int = GameInfo.current_reward.get_type()
	match type:
		Reward.WEAPON:
			if card_number == Cards.REPLACE_1:
				player.weapon1.queue_free()
				player.weapon1 = Weapon.new(GameInfo.current_reward.get_as_weapon_res(), GameInfo.current_reward.get_rarity(), ShootEntity.Owner.PLAYER)
				player.activate_weapon1()
				player.weapon_marker.add_child(player.weapon1)
			elif card_number == Cards.REPLACE_2:
				player.weapon2.queue_free()
				player.weapon2 = Weapon.new(GameInfo.current_reward.get_as_weapon_res(), GameInfo.current_reward.get_rarity(), ShootEntity.Owner.PLAYER)
				player.activate_weapon2()
				player.weapon_marker.add_child(player.weapon2)
			elif card_number == Cards.TAKE_OR_CONSUME_3:
				player.weapon2 = Weapon.new(GameInfo.current_reward.get_as_weapon_res(), GameInfo.current_reward.get_rarity(), ShootEntity.Owner.PLAYER)
				player.activate_weapon2()
				player.weapon_marker.add_child(player.weapon2)
		
		Reward.ACTIVITY:
			if not card_number == Cards.TAKE_OR_CONSUME_3:
				player.activity.queue_free()
			player.activity = Activity.new(GameInfo.current_reward.get_as_activity_res(), GameInfo.current_reward.get_rarity())
			player.add_child(player.activity)
		
		Reward.DEMON_PASSIVITY:
			player.apply_demon_passivity(GameInfo.current_reward.get_as_demon_passivity_res(), GameInfo.current_reward.get_rarity())
		
		Reward.WEAPON_PASSIVITY:
			pass
		
		Reward.SHOOT_ENTITY_STATUS:
			pass
		
		_:
			assert(false, "Wrong type = " + str(type))
	
	GameInfo.current_reward = null
	
	hide_all()

func hide_all():
	need_kill_tween.emit()
	for dict in _button1.pressed.get_connections() as Array[Dictionary]:
		_button1.pressed.disconnect(dict["callable"])
	for dict in _button2.pressed.get_connections() as Array[Dictionary]:
		_button2.pressed.disconnect(dict["callable"])
	for dict in _button3.pressed.get_connections() as Array[Dictionary]:
		_button3.pressed.disconnect(dict["callable"])
	
	var tween := create_tween()
	tween.tween_property(
			self, "position:y",
			- Global.SCREEN_HEIGHT,
			1.0
	).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN)
	tween.tween_callback(
			func():
				_card1.hide()
				_card2.hide()
				_card3.hide()
				self.hide()
	)
	tween.finished.connect(tween.kill, CONNECT_ONE_SHOT)
