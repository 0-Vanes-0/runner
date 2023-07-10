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

@export var info_label: Label
@export var player_sensor: PlayerSensor
@export var shoot_sensor: ShootSensor
@export var game_over_menu: GameOverMenu
@export var pause_menu: PauseMenu
@export var black_color_rect: ColorRect


func _ready() -> void:
	assert(
			level and bounds and bounds_top and bounds_right and bounds_bottom and bounds_left and segments and enemies and shoot_field
			and info_label and player_sensor and shoot_sensor and game_over_menu and pause_menu and black_color_rect
	)
	black_color_rect.color = Color(0, 0, 0, 0)
	game_over_menu.restart_called.connect(
			func():
				init_game()
	)
	
	Global.need_apply_settings.emit()
	init_bounds()
	init_game()


func _physics_process(delta: float) -> void:
	if not is_level_complete:
		for segment in (segments.get_children() as Array[Segment]):
			segment.move(delta * Global.player.run_speed)
	
	if is_enemies_permitted and enemies.get_child_count() == 0:
		var enemy: Enemy = Preloader.enemy_test_dragon.instantiate()
		enemy.dead.connect(
				func():
					GameInfo.kills_count += 1
		, CONNECT_ONE_SHOT)
		enemies.add_child(enemy)


func _notification(what: int) -> void:
	if what == NOTIFICATION_WM_GO_BACK_REQUEST:
		pause_game()


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.keycode == KEY_ESCAPE:
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
		var player := Global.player
		player.player_sensor = player_sensor
		player.shoot_sensor = shoot_sensor
		player.name = "Player"
		level.add_child(player)
		level.move_child(player, segments.get_index() + 1)
		player.state_dead.died.connect(
				func():
					game_over_menu.appear()
					is_enemies_permitted = false
		)
		player.call_level_end_objects.connect(process_level_end_objects)
		player.health_comp.health = 100
		player.stamina_max = 100.0
		player.run_speed = Platform.SIZE.x * 2
		player.dodge_time = 1.0
	
	Global.player.prepare_to_run()


func setup_level():
	for child in (segments.get_children() as Array[Segment]):
		child.queue_free()
	
	var biome_segments: Array[Segment] = Preloader.get_segments_by_biome(GameInfo.biome_number)
	var LEVEL_LENGTH: int = GameInfo.get_level_length(GameInfo.level_number)
	var segments_length: int = 0
	for segment_i in GameInfo.get_level_segments_numbers(GameInfo.biome_number, GameInfo.level_number):
		var segment: Segment = biome_segments[segment_i].clone()
		segment.position.x = segments_length * Global.PLATFORM_W
		segments_length += segment.get_length()
		segments.add_child(segment, true)
	
	var last_segment := segments.get_child(-1) as Segment
	last_segment.cut_segment_at(last_segment.get_length() - (segments_length - LEVEL_LENGTH))
	last_segment.is_last = true
	last_segment.level_about_to_end.connect(_remove_enemies)
	last_segment.level_end.connect(_on_level_complete)
	var plane: Segment = Preloader.default_segment.duplicate()
	plane.name = "Plane"
	plane.position.x = LEVEL_LENGTH * Global.PLATFORM_W
	segments.add_child(plane)
	
	Global.player.platforms_left = LEVEL_LENGTH
	
	var tween := create_tween()
	tween.tween_property(
			black_color_rect,
			"color:a",
			1.0,
			0
	)
	tween.tween_property(
			black_color_rect,
			"color:a",
			0.0,
			Global.LEVEL_END_TIME * 0.5
	)
	tween.tween_property(
			self,
			"is_level_complete",
			false,
			0
	)
	tween.tween_property(
			self,
			"is_enemies_permitted",
			true,
			0
	)

## Called after finishing level, when [Player] reachs idle animation.
func process_level_end_objects():
	var player := Global.player
	var chest_sprite := Sprite2D.new() # Chest
	chest_sprite.name = "Chest"
	chest_sprite.texture = preload("res://assets/sprites/mothership.png")
	# WHEN I'LL HAVE BETTER PLAYER SPRITES - REMOVE --> / 2
	chest_sprite.scale = player.get_game_size() / 2 / chest_sprite.texture.get_size()
	segments.add_child(chest_sprite)
	chest_sprite.position = player.position + Vector2.RIGHT * player.get_game_size().x / 2
	
	var portal_poses: Array[Vector2] = [
		player.position + Vector2.RIGHT * Global.screen_width / 4 + Vector2.UP * player.get_game_size() / 2,
		player.position + Vector2.LEFT * Global.screen_width / 4 + Vector2.UP * player.get_game_size() / 2,
		player.position + Vector2.UP * Global.screen_height / 2 + Vector2.UP * player.get_game_size() / 2,
	]
	var portal_colors: Array[Color] = [
		Color.RED,
		Color.GREEN,
		Color.BLUE,
	]
	for i in 3:
		var portal := Portal.new(player.get_game_size(), portal_colors[i])
		portal.name = "Portal" + str(i)
		# WHEN I'LL HAVE BETTER PLAYER SPRITES - MAKE --> * 2
		segments.add_child(portal)
		portal.position = portal_poses[i]
		
		portal.portal_chosen.connect(
				func():
					player.go_to_portal.emit(portal_poses[i])
					var anon_tween := create_tween()
					anon_tween.tween_property(
							black_color_rect,
							"color:a",
							1.0,
							Global.LEVEL_END_TIME
					)
		, CONNECT_ONE_SHOT)
	
	player.in_portal.connect(
			func():
				GameInfo.level_number = min(GameInfo.level_number + 1, GameInfo.LEVELS_COUNT)
				setup_player()
				setup_level()
	, CONNECT_ONE_SHOT)


func init_bounds():
	(bounds_top.shape as SegmentShape2D).a = Vector2(0, 0)
	(bounds_top.shape as SegmentShape2D).b = Vector2(Global.screen_width, 0)
	(bounds_right.shape as SegmentShape2D).a = Vector2(Global.screen_width, 0)
	(bounds_right.shape as SegmentShape2D).b = Vector2(Global.screen_width, Global.screen_height)
	(bounds_bottom.shape as SegmentShape2D).a = Vector2(Global.screen_width, Global.screen_height)
	(bounds_bottom.shape as SegmentShape2D).b = Vector2(0, Global.screen_height)
	(bounds_left.shape as SegmentShape2D).a = Vector2(0, Global.screen_height)
	(bounds_left.shape as SegmentShape2D).b = Vector2(0, 0)
	Global.clean_layers(bounds).set_collision_layer_value(Global.Layers.BOUNDS, true)


func get_shoot_field() -> Node2D:
	return shoot_field


func _on_level_complete():
	is_level_complete = true
	Global.player.state_machine.transition_to(Global.player.state_level_end)


func _remove_enemies():
	is_enemies_permitted = false
	for enemy in (enemies.get_children() as Array[Enemy]):
		enemy.state_machine.transition_to(enemy.state_go_away, true)
