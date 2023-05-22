extends Node2D

@onready var player: Player = $Player 
@onready var floors: Node2D = $Floors
@onready var bounds: StaticBody2D = $Bounds
const FLOORS_COUNT = 4

func _ready():
	var height := Global.screen_height
	var jump_height: float
	var platform_width: float
	
	for i in FLOORS_COUNT:
		var floor := Node2D.new()
		floors.add_child(floor)
		floor.name = "Floor" + str(i)
		
		var platform: Platform = Preloader.platform.instantiate()
		floor.add_child(platform)
		platform.position.x = platform.size.x
		Global.floor_group_names.append(floor.name)
		platform.add_to_group(Global.floor_group_names[i])
		platform_width = platform.size.x
		
		var gap: float = (height - platform.size.y) / FLOORS_COUNT
		floor.position.y = height - platform.size.y - i * gap
		jump_height = gap + platform.size.y
	
	player.position = Vector2(platform_width / 2, Global.screen_height / 2)
	player.jump_speed = sqrt(2 * player.gravity * jump_height)
	
	($Bounds/Top.shape as SegmentShape2D).a = Vector2(0, 0)
	($Bounds/Top.shape as SegmentShape2D).b = Vector2(Global.screen_width, 0)
	($Bounds/Right.shape as SegmentShape2D).a = Vector2(Global.screen_width, 0)
	($Bounds/Right.shape as SegmentShape2D).b = Vector2(Global.screen_width, Global.screen_height)
	($Bounds/Bottom.shape as SegmentShape2D).a = Vector2(Global.screen_width, Global.screen_height)
	($Bounds/Bottom.shape as SegmentShape2D).b = Vector2(0, Global.screen_height)
	($Bounds/Left.shape as SegmentShape2D).a = Vector2(0, Global.screen_height)
	($Bounds/Left.shape as SegmentShape2D).b = Vector2(0, 0)
	Global.clean_layers($Bounds).set_collision_layer_value(Global.Layers.BOUNDS, true)
