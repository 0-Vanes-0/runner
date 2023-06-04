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
const MAX_FLOORS := 4
const JUMP_DOWN_DISABLE_TIME := 0.1
var screen_width: int; var screen_height: int; var ratio := ":"


func _ready() -> void:
	screen_width = int(get_viewport().get_visible_rect().size.x)
	screen_height = int(get_viewport().get_visible_rect().size.y)
	var gcd := _gcd(screen_width, screen_height)
	ratio = str(screen_width / gcd) + ratio + str(screen_height / gcd)
	print_debug("\t", "screen_width=", screen_width, ", screen_height=", screen_height, ", ratio=", ratio)
	
	Preloader.error.connect(_on_preloader_error)
	
	RenderingServer.set_default_clear_color(Color(0, 0, 0))
	
	randomize()

# ---------------------- FUNCTIONS ----------------------

func clean_layers(obj: CollisionObject2D) -> CollisionObject2D:
	obj.set_collision_layer_value(1, false)
	obj.set_collision_mask_value(1, false)
	return obj


func _on_preloader_error(message: String):
	print_debug(message)

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
	elif  event is InputEventKey and event.keycode == KEY_TAB:
		get_tree().reload_current_scene()


func _notification(what: int) -> void:
	if what == NOTIFICATION_WM_GO_BACK_REQUEST:
		get_tree().quit()
