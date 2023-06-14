extends Node2D

var is_level_complete: bool
var is_enemies_permitted: bool
@onready var bounds := $Bounds as StaticBody2D
@onready var segments := $Segments as Node2D
@onready var player := $Player as Player
@onready var enemies := $Enemies as Node2D
@onready var black_color_rect := $"../HUD/BlackColorRect" as ColorRect
@onready var info_label := $"../HUD/InfoLabel" as Label


func _ready() -> void:
	var jump_height: float = (Global.screen_height - Platform.SIZE.y) / Global.MAX_FLOORS + Platform.SIZE.y
	player.jump_speed = sqrt(2 * player.gravity * jump_height)
	player.state_dead.died.connect(func(): pass) # show_game_over_menu
	player.call_level_end_objects.connect(process_level_end_objects)
	
	($Bounds/Top.shape as SegmentShape2D).a = Vector2(0, 0)
	($Bounds/Top.shape as SegmentShape2D).b = Vector2(Global.screen_width, 0)
	($Bounds/Right.shape as SegmentShape2D).a = Vector2(Global.screen_width, 0)
	($Bounds/Right.shape as SegmentShape2D).b = Vector2(Global.screen_width, Global.screen_height)
	($Bounds/Bottom.shape as SegmentShape2D).a = Vector2(Global.screen_width, Global.screen_height)
	($Bounds/Bottom.shape as SegmentShape2D).b = Vector2(0, Global.screen_height)
	($Bounds/Left.shape as SegmentShape2D).a = Vector2(0, Global.screen_height)
	($Bounds/Left.shape as SegmentShape2D).b = Vector2(0, 0)
	Global.clean_layers($Bounds).set_collision_layer_value(Global.Layers.BOUNDS, true)
	
	black_color_rect.color.a = 0
	setup_level()


func _physics_process(delta: float) -> void:
	if not is_level_complete:
		for segment in segments.get_children():
			if segment is Segment:
				segment.move(delta * player.run_speed)
	
	if is_enemies_permitted and enemies.get_child_count() == 0:
		var enemy: Enemy = Preloader.enemy_test_dragon.instantiate()
		enemy.dead.connect(info_label.on_enemy_dead)
		enemies.add_child(enemy)


func setup_level():
	for child in segments.get_children():
		child.queue_free()
	
	Preloader.segments.shuffle()
	var size: int = Preloader.segments.size()
	var segments_length_x: float
	for i in size:
		var segment: Segment = Preloader.segments[i].clone()
		segment.position.x = segments_length_x
		segments_length_x += segment.get_width()
		segments.add_child(segment, true)
		if i == size - 1:
			segment.is_last = true
			segment.level_about_to_end.connect(_remove_enemies)
			segment.level_end.connect(_on_level_complete)
			var plane: Segment = Preloader.default_segment.duplicate()
			plane.name = "Plane"
			plane.position.x = segments_length_x
			segments.add_child(plane)
	
	player.position = Vector2(Global.screen_width / 10, Global.screen_height / 2)
	player.run_speed = Platform.SIZE.x * 2
	player.dodge_time = 1.0
	player.state_machine.transition_to(player.state_run, true)
	
	is_level_complete = false
	is_enemies_permitted = true


func process_level_end_objects():
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
				var anon_tween := create_tween()
				anon_tween.tween_property(
					black_color_rect,
					"color:a",
					0.0,
					Global.LEVEL_END_TIME * 0.5
				)
				setup_level()
		, CONNECT_ONE_SHOT)


func _on_level_complete():
	is_level_complete = true
	player.state_machine.transition_to(player.state_level_end)


func _remove_enemies():
	is_enemies_permitted = false
	for enemy in enemies.get_children():
		if enemy is Enemy:
			enemy.state_machine.transition_to(enemy.state_go_away)
