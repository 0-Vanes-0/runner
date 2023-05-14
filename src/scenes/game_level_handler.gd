extends Node2D

@onready var player: Player = $Player 
@onready var floors: Node2D = $Floors
const FLOORS_COUNT = 4

func _ready():
	var height := Global.screen_height
	var jump_height: float
	
	for i in FLOORS_COUNT:
		var floor := Node2D.new()
		floors.add_child(floor)
		floor.name = "Floor" + str(i)
		
		var platform: Platform = Preloader.platform.instantiate()
		floor.add_child(platform)
		platform.position.x = platform.size.x
		Global.floor_group_names.append(floor.name)
		platform.add_to_group(Global.floor_group_names[i])
		
		var gap: float = (height - platform.size.y) / FLOORS_COUNT
		floor.position.y = height - platform.size.y - i * gap
		jump_height = gap + platform.size.y
	
	player.position.y = Global.screen_height / 2
	player.jump_speed = sqrt(2 * player.gravity * jump_height)
