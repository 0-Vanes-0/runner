extends Node2D

@onready var player := $Player as Player
const FLOORS_COUNT = 4
var floors: Array[Node2D]

func _ready():
	var height := Global.screen_height
	var jump_height: float
	
	for i in FLOORS_COUNT:
		var floor := Node2D.new()
		self.add_child(floor)
		floor.name = "Floor" + str(i)
		
		var platform: Platform = preload("res://src/gameplay/enviroment/platform.tscn").instantiate()
		floor.add_child(platform)
		platform.position.x = platform.size.x
		Global.floor_group_names.append(floor.name)
		platform.add_to_group(Global.floor_group_names[i])
		
		var gap: float = (height - platform.size.y) / FLOORS_COUNT
		floor.position.y = height - platform.size.y - i * gap
		jump_height = gap + platform.size.y
		
		floors.append(floor)
	
	player.jump_speed = sqrt(2 * player.gravity * jump_height)
	self.move_child(player, -1)
