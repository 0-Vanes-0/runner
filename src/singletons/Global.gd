extends Node
# This is global script which stores global variables and helps with some global processes
# like pausing game, finding nodes at tree, switching scenes etc.

# ---------------------- VARIABLES ----------------------

enum Layers {
	PLATFORM = 1,
	PLAYER = 2,
	ENEMY = 3,
	SHOOT_ENTITY_PLAYER = 4,
	SHOOT_ENTITY_ENEMY = 5,
	BOUNDS = 6,
}
const MAX_FLOORS: int = 4
const JUMP_DOWN_DISABLE_TIME := 0.1
const LEVEL_END_TIME := 1.5
const PLATFORM_W := Platform.SIZE.x
const PLATFORM_H := Platform.SIZE.y
var FLOORS_GAP: float
var ENEMY_SPAWN_SPOTS: Array[float]

var player: Player
var game_res_loaded := false

var screen_width: int; var screen_height: int; var ratio := ":"


func _ready() -> void:
	screen_width = int(get_viewport().get_visible_rect().size.x)
	screen_height = int(get_viewport().get_visible_rect().size.y)
	var gcd := _gcd(screen_width, screen_height)
	ratio = str(screen_width / gcd) + ratio + str(screen_height / gcd)
	print_debug("\t", "screen_width=", screen_width, ", screen_height=", screen_height, ", ratio=", ratio)
	
	FLOORS_GAP = (screen_height - PLATFORM_H) / Global.MAX_FLOORS
	ENEMY_SPAWN_SPOTS.append(FLOORS_GAP * 0.5)
	ENEMY_SPAWN_SPOTS.append(FLOORS_GAP * 1.5)
	ENEMY_SPAWN_SPOTS.append(FLOORS_GAP * 2.5)
	ENEMY_SPAWN_SPOTS.append(FLOORS_GAP * 3.5)
	
	RenderingServer.set_default_clear_color(Color(0, 0, 0))
	
	randomize()

# ---------------------- FUNCTIONS ----------------------

func clean_layers(obj: CollisionObject2D) -> CollisionObject2D:
	obj.set_collision_layer_value(1, false)
	obj.set_collision_mask_value(1, false)
	return obj


# NOD
func _gcd(a: int, b: int) -> int:
	while a > 0 and b > 0:
		if a > b:
			a %= b
		else:
			b %= a
	return a + b


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.keycode == KEY_ESCAPE:
		get_tree().quit()


func _notification(what: int) -> void:
	if what == NOTIFICATION_WM_GO_BACK_REQUEST:
		get_tree().quit()
