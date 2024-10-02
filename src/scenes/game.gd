class_name GameScene
extends Node2D

var is_level_complete: bool ## If [code]true[/code], level stops moving. It becomes false on [method setup_level].
var is_enemies_permitted: bool ## If [code]true[/code], enemies can spawn. It becomes false if player dies or level is complete.
@export var level: Node2D
@export var bounds: StaticBody2D
@export var bounds_top: CollisionShape2D
@export var bounds_right: CollisionShape2D
@export var bounds_bottom: CollisionShape2D
@export var bounds_left: CollisionShape2D
@export var segments: Node2D
@export var enemies: Node2D
@export var shoot_field: Node2D
@export var camera: Camera2D

@export var player_sensor: PlayerSensor
@export var left_menu: LeftMenu
@export var shoot_sensor: ShootSensor
@export var game_over_menu: GameOverMenu
@export var reward_menu: RewardMenu
@export var black_color_rect: ColorRect
@export var pause_menu: PauseMenu
@export var info_label: Label


func _ready() -> void:
	assert(
			level and bounds and bounds_top and bounds_right and bounds_bottom and bounds_left and segments and enemies and shoot_field and camera
			and info_label and player_sensor and left_menu and shoot_sensor and game_over_menu and reward_menu and pause_menu and black_color_rect
	)
	black_color_rect.color = Color(0, 0, 0, 0)
	game_over_menu.restart_called.connect(
			func():
				init_game()
	)
	$Level/DeadArea.body_entered.connect( # Just for debugging
			func(body: Node2D):
				if body is Player:
					body.state_machine.transition_to(body.state_dead, true)
	)
	
	Global.need_apply_settings.emit()
	_init_bounds()
	init_game()


func _physics_process(delta: float) -> void:
	if not is_level_complete:
		for segment in segments.get_children() as Array[Segment]:
			segment.move(delta * Global.player.current_run_speed)
	
	if is_enemies_permitted and enemies.get_child_count() < 3:
		var enemy: Enemy = Preloader.enemy_sphere_mage.instantiate()
		enemy.dead.connect(
				func():
					GameInfo.kills_count += 1
		, CONNECT_ONE_SHOT)
		enemies.add_child(enemy)
	
	if Global.player != null:
		camera.position = Global.player.position


func _notification(what: int) -> void:
	if what == NOTIFICATION_WM_GO_BACK_REQUEST:
		pause_game()


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.keycode == KEY_ESCAPE:
		pause_game()


func _on_pause_button_pressed():
	pause_game()

## Called when this scene is ready. The function spawns player and setups level according to [GameInfoSingleton].
func init_game():
	GameInfo.setup_game_info()
	setup_player(true)
	setup_level()


func pause_game():
	pause_menu.show()
	get_tree().paused = true

## Prepares [member GlobalSingleton.player] to run. If [param need_create_instance] is [code]true[/code], new instance of [Player] will be created.
func setup_player(need_create_instance: bool = false):
	if Global.player == null or need_create_instance:
		Global.player = Preloader.player.instantiate() as Player
		var player := Global.player as Player
		player.player_sensor = player_sensor
		player.shoot_sensor = shoot_sensor
		player.apply_player_data()
		player.state_dead.died.connect( func():
					game_over_menu.appear()
					is_enemies_permitted = false
		, CONNECT_ONE_SHOT)
		player.call_level_end_objects.connect(process_level_end_objects)
		level.add_child(player)
		left_menu.init_connections()
	
	Global.player.prepare_to_run()


func setup_level():
	for child in segments.get_children() as Array[Segment]:
		child.queue_free()
	for child in enemies.get_children() as Array[Enemy]:
		child.queue_free()
	for child in shoot_field.get_children() as Array[ShootEntity]:
		child.queue_free()
	
	var biome_segments: Array[Segment] = Preloader.get_segments(GameInfo.biome_number)
	var LEVEL_LENGTH: int = GameInfo.get_level_length(GameInfo.level_number)
	var segments_length: int = 0
	for segment_i in GameInfo.get_level_segments_numbers(GameInfo.biome_number, GameInfo.level_number):
		var segment: Segment = biome_segments[segment_i].clone()
		segment.position.x = segments_length * Platform.SIZE.x
		segments_length += segment.get_length()
		segments.add_child(segment, true)
	
	var last_segment := segments.get_child(-1) as Segment
	last_segment.cut_segment_at(last_segment.get_length() - (segments_length - LEVEL_LENGTH))
	last_segment.is_last = true
	last_segment.level_about_to_end.connect(_remove_enemies)
	last_segment.level_end.connect(_on_level_complete)
	var plane: Segment = Preloader.default_segment.duplicate()
	plane.name = "Plane"
	plane.position.x = LEVEL_LENGTH * Platform.SIZE.x
	segments.add_child(plane)
	
	Global.player.platforms_left = LEVEL_LENGTH

	Global.camera.position_smoothing_speed = 1.0
	
	var tween := create_tween()
	tween.tween_property(
			black_color_rect, "color:a",
			1.0,
			0
	)
	tween.tween_property(
			black_color_rect, "color:a",
			0.0,
			1.0
	)
	tween.tween_property(
			self, "is_level_complete",
			false,
			0
	)
	tween.tween_property(
			self, "is_enemies_permitted",
			true,
			0
	)

## Called after finishing level, when [Player] reachs idle animation.
func process_level_end_objects():
	var player := Global.player as Player
	
	var chest := Preloader.chest.instantiate() as Chest
	chest.reward = GameInfo.current_reward
	chest.scale = (player.get_game_size() / 2) / chest.sprite.sprite_frames.get_frame_texture("default", 0).get_size()
	chest.position = player.position + Vector2.RIGHT * player.get_game_size().x * 1.5
	segments.add_child(chest)
	chest.clicked.connect(
			func():
				match GameInfo.current_reward.get_type():
					Reward.WEAPON:
						reward_menu.show_weapons()
						reward_menu.choosed.connect(_spawn_portals, CONNECT_ONE_SHOT)
					Reward.ACTIVITY:
						reward_menu.show_activities()
						reward_menu.choosed.connect(_spawn_portals, CONNECT_ONE_SHOT)
					Reward.DEMON_PASSIVITY:
#						reward_menu.show_demon_passivities()
#						reward_menu.choosed.connect(_spawn_portals, CONNECT_ONE_SHOT)
						player.apply_demon_passivity(GameInfo.current_reward.get_as_demon_passivity_res(), GameInfo.current_reward.get_rarity())
						GameInfo.current_reward = null
						_spawn_portals()
					Reward.WEAPON_PASSIVITY:
						pass
#						reward_menu.show_weapon_passivities()
#						reward_menu.choosed.connect(_spawn_portals, CONNECT_ONE_SHOT)
				
				player.in_portal.connect( func():
							GameInfo.level_number = clampi(GameInfo.level_number + 1, 1, GameInfo.LEVELS_COUNT)
							setup_player()
							setup_level()
				, CONNECT_ONE_SHOT)
	)


func get_shoot_field() -> Node2D:
	return shoot_field


func _spawn_portals():
	var player := Global.player as Player
	
	var portal_poses: Array[Vector2] = [
		player.position + Vector2.RIGHT * Global.SCREEN_WIDTH / 5 + Vector2.UP * player.get_game_size(),
		player.position + Vector2.LEFT * Global.SCREEN_WIDTH / 5 + Vector2.UP * player.get_game_size(),
		player.position + Vector2.UP * Global.SCREEN_HEIGHT / 3 + Vector2.UP * player.get_game_size(),
	]
	var rewards := GameInfo.get_rewards_array(GameInfo.biome_number, GameInfo.level_number)
	for i in rewards.size():
		var portal := Preloader.portal.instantiate() as Portal
		portal.set_reward(rewards[i])
		portal.name = "Portal" + str(i)
		portal.position = portal_poses[i]
		portal.portal_chosen.connect(
				func(reward: Reward):
					if GameInfo.current_reward == null:
						GameInfo.current_reward = reward
						player.go_to_portal.emit(portal_poses[i])
						var anon_tween := create_tween()
						anon_tween.tween_property(black_color_rect, "color:a", 1.0, 1.0)
		, CONNECT_ONE_SHOT)
		
		segments.add_child(portal)


func _init_bounds():
	var left_top := Vector2(Global.BORDER_LEFT, Global.BORDER_TOP)
	var right_top := Vector2(Global.BORDER_RIGHT, Global.BORDER_TOP)
	var right_bottom := Vector2(Global.BORDER_RIGHT, Global.BORDER_BOTTOM)
	var left_bottom := Vector2(Global.BORDER_LEFT, Global.BORDER_BOTTOM)
	(bounds_top.shape as SegmentShape2D).a = left_top
	(bounds_top.shape as SegmentShape2D).b = right_top
	(bounds_right.shape as SegmentShape2D).a = right_top
	(bounds_right.shape as SegmentShape2D).b = right_bottom
	(bounds_bottom.shape as SegmentShape2D).a = right_bottom
	(bounds_bottom.shape as SegmentShape2D).b = left_bottom
	(bounds_left.shape as SegmentShape2D).a = left_bottom
	(bounds_left.shape as SegmentShape2D).b = left_top
	Global.clean_layers(bounds).set_collision_layer_value(Global.Layers.BOUNDS, true)

	camera.limit_top = Global.BORDER_TOP
	camera.limit_right = Global.BORDER_RIGHT
	camera.limit_bottom = Global.BORDER_BOTTOM
	camera.limit_left = Global.BORDER_LEFT
	Global.camera = camera


func _on_level_complete():
	is_level_complete = true
	Global.player.state_machine.queue_transition_to(Global.player.state_level_end)
	Global.player.status_handler.clear_statuses()
	Global.player.sprite.modulate = Global.player.health_comp.orig_modulate
	Global.camera.position_smoothing_speed = 10.0


func _remove_enemies():
	is_enemies_permitted = false
	for enemy in enemies.get_children() as Array[Enemy]:
		enemy.state_machine.transition_to(enemy.state_go_away)
