## This is global script which stores global variables and helps with some global processes
## like pausing game, finding nodes at tree, switching scenes etc.
extends Node

# ---------------------- VARIABLES ----------------------

## This signal is called when settings are changed. Usually it's emitted after pressing "Back" button
##  of [SettingsMenu] or "Play" button on [MainMenu] (if player avoided pressing "Back" button).
signal need_apply_settings
## These are collision layers. Every [CollisionObject2D] must have one of collision layers
## and several collision masks, depending on it's behaviour.
enum Layers {
	PLATFORM = 1,
	PLAYER = 2,
	ENEMY = 3,
	SHOOT_ENTITY_PLAYER = 4,
	SHOOT_ENTITY_ENEMY = 5,
	BOUNDS = 6,
}
## Max amount of floors in game.
const MAX_FLOORS: int = 8
## Max amount of floors that can be seen in one screen.
const MAX_SCREEN_FLOORS: int = 4
## Const distance between floors.
var FLOORS_GAP: float
## 
var BORDER_TOP: float
var BORDER_RIGHT: float
var BORDER_BOTTOM: float
var BORDER_LEFT: float
## Array of 4 spots of spawning enemies.
var ENEMY_Y_SPOTS: Array[float]
## Default enemy x position.
var ENEMY_X_POSITION: float
## Structure: [code]{ String: { String: Variant } }[/code].
var DEFAULT_SETTINGS: Dictionary = {
	Text.CONTROLS: {
		Text.DODGE_SWIPE: false,
		Text.RELOAD_SWIPE: false,
		Text.SWITCH_WEAPON_SWIPE: false,
		Text.ACTIVITY_SWIPE: false,
	},
	Text.AUDIO: {
		Text.MUSIC: true
	},
}
## Const size of [SensorButton] in [GameScene].
var SENSOR_BUTTON_SIZE: Vector2

## For more comfort access the Player is moved here and this field must be updated on every Player creation.
var player: Player
var player_data: DemonData
var camera: Camera2D
## This variable controls if all assets are loaded. (WIP: add progress bar class or smth)
var game_res_loaded := false
## This variable stores settings data from file (see [SaveLoadSingleton]).
var settings: Dictionary = {}
## Screen info, calculated at start of project.
var SCREEN_WIDTH: int; var SCREEN_HEIGHT: int; var RATIO := ":"


func _ready() -> void:
	setup()


func setup():
	SCREEN_WIDTH = int(get_viewport().get_visible_rect().size.x)
	SCREEN_HEIGHT = int(get_viewport().get_visible_rect().size.y)
	var gcd := _gcd(SCREEN_WIDTH, SCREEN_HEIGHT)
	RATIO = str(SCREEN_WIDTH / gcd) + RATIO + str(SCREEN_HEIGHT / gcd)
	print_debug("\t", "SCREEN_WIDTH=", SCREEN_WIDTH, ", SCREEN_HEIGHT=", SCREEN_HEIGHT, ", RATIO=", RATIO)

	Platform.SIZE = Vector2(Global.SCREEN_WIDTH / 4, Global.SCREEN_HEIGHT / 30)
	SENSOR_BUTTON_SIZE = Vector2.ONE * SCREEN_HEIGHT * 0.2
	FLOORS_GAP = (SCREEN_HEIGHT - Platform.SIZE.y) / Global.MAX_SCREEN_FLOORS
	
	BORDER_TOP = Global.SCREEN_HEIGHT - (Global.MAX_FLOORS + 1) * (Global.FLOORS_GAP + Platform.SIZE.y)
	BORDER_RIGHT = Global.SCREEN_WIDTH
	BORDER_BOTTOM = Global.SCREEN_HEIGHT
	BORDER_LEFT = 0.0

	ENEMY_Y_SPOTS.append(0.0)
	for i in MAX_FLOORS:
		ENEMY_Y_SPOTS.append(SCREEN_HEIGHT - FLOORS_GAP * (0.5 + i))
	ENEMY_X_POSITION = Global.SCREEN_WIDTH * 0.8
	
	settings = SaveLoad.load_settings()
	
	RenderingServer.set_default_clear_color(Color(0, 0, 0))
	
	randomize()

# ---------------------- FUNCTIONS ----------------------

## Resets collision layers and masks of [param obj] and returns it.
func clean_layers(obj: CollisionObject2D) -> CollisionObject2D:
	obj.set_collision_layer_value(1, false)
	obj.set_collision_mask_value(1, false)
	return obj

## Tells to [SceneHandler] to switch to [PackedScene].
func switch_to_scene(scene: PackedScene):
	var scene_handler = get_tree().current_scene
	if scene_handler is SceneHandler:
		scene_handler.switch_to_scene(scene)
	else:
		print_debug("scene_handler is missing!!!")

## Returns current scene of [SceneHandler].
func get_current_scene() -> Node:
	var scene_handler = get_tree().current_scene
	if scene_handler is SceneHandler:
		return scene_handler.current_scene
	else:
		print_debug("scene_handler is missing!!!")
		return null

## Returns current scene as [GameScene]. If it's not, returns null.
func get_game_scene() -> GameScene:
	var scene = get_current_scene()
	if scene is GameScene:
		return scene
	else:
		return null


func create_ui_label(size: int = 36) -> Label:
	var label := Label.new()
	label.add_theme_font_size_override("font_size", size)
	label.add_theme_font_override("font", preload("res://assets/fonts/vcrosdmonorusbyd.ttf"))
	label.add_theme_constant_override("outline_size", size/2)
	label.add_theme_color_override("font_outline_color", Color.BLACK)
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	return label

## Returns [param error] as [String].
func parse_error(error: Error) -> String:
	match error:
		OK: return "OK"
		FAILED: return "FAILED"
		ERR_UNAVAILABLE: return "ERR_UNAVAILABLE"
		ERR_UNCONFIGURED: return "ERR_UNCONFIGURED"
		ERR_UNAUTHORIZED: return "ERR_UNAUTHORIZED"
		ERR_PARAMETER_RANGE_ERROR: return "ERR_PARAMETER_RANGE_ERROR"
		ERR_OUT_OF_MEMORY: return "ERR_OUT_OF_MEMORY"
		ERR_FILE_NOT_FOUND: return "ERR_FILE_NOT_FOUND"
		ERR_FILE_BAD_DRIVE: return "ERR_FILE_BAD_DRIVE"
		ERR_FILE_BAD_PATH: return "ERR_FILE_BAD_PATH"
		ERR_FILE_NO_PERMISSION: return "ERR_FILE_NO_PERMISSION"
		ERR_FILE_ALREADY_IN_USE: return "ERR_FILE_ALREADY_IN_USE"
		ERR_FILE_CANT_OPEN: return "ERR_FILE_CANT_OPEN"
		ERR_FILE_CANT_WRITE: return "ERR_FILE_CANT_WRITE"
		ERR_FILE_CANT_READ: return "ERR_FILE_CANT_READ"
		ERR_FILE_UNRECOGNIZED: return "ERR_FILE_UNRECOGNIZED"
		ERR_FILE_CORRUPT: return "ERR_FILE_CORRUPT"
		ERR_FILE_MISSING_DEPENDENCIES: return "ERR_FILE_MISSING_DEPENDENCIES"
		ERR_FILE_EOF: return "ERR_FILE_EOF"
		ERR_CANT_OPEN: return "ERR_CANT_OPEN"
		ERR_CANT_CREATE: return "ERR_CANT_CREATE"
		ERR_QUERY_FAILED: return "ERR_QUERY_FAILED"
		ERR_ALREADY_IN_USE: return "ERR_ALREADY_IN_USE"
		ERR_LOCKED: return "ERR_LOCKED"
		ERR_TIMEOUT: return "ERR_TIMEOUT"
		ERR_CANT_CONNECT: return "ERR_CANT_CONNECT"
		ERR_CANT_RESOLVE: return "ERR_CANT_RESOLVE"
		ERR_CONNECTION_ERROR: return "ERR_CONNECTION_ERROR"
		ERR_CANT_ACQUIRE_RESOURCE: return "ERR_CANT_ACQUIRE_RESOURCE"
		ERR_CANT_FORK: return "ERR_CANT_FORK"
		ERR_INVALID_DATA: return "ERR_INVALID_DATA"
		ERR_INVALID_PARAMETER: return "ERR_INVALID_PARAMETER"
		ERR_ALREADY_EXISTS: return "ERR_ALREADY_EXISTS"
		ERR_DOES_NOT_EXIST: return "ERR_DOES_NOT_EXIST"
		ERR_DATABASE_CANT_READ: return "ERR_DATABASE_CANT_READ"
		ERR_DATABASE_CANT_WRITE: return "ERR_DATABASE_CANT_WRITE"
		ERR_COMPILATION_FAILED: return "ERR_COMPILATION_FAILED"
		ERR_METHOD_NOT_FOUND: return "ERR_METHOD_NOT_FOUND"
		ERR_LINK_FAILED: return "ERR_LINK_FAILED"
		ERR_SCRIPT_FAILED: return "ERR_SCRIPT_FAILED"
		ERR_CYCLIC_LINK: return "ERR_CYCLIC_LINK"
		ERR_INVALID_DECLARATION: return "ERR_INVALID_DECLARATION"
		ERR_DUPLICATE_SYMBOL: return "ERR_DUPLICATE_SYMBOL"
		ERR_PARSE_ERROR: return "ERR_PARSE_ERROR"
		ERR_BUSY: return "ERR_BUSY"
		ERR_SKIP: return "ERR_SKIP"
		ERR_HELP: return "ERR_HELP"
		ERR_BUG: return "ERR_BUG"
		ERR_PRINTER_ON_FIRE: return "ERR_PRINTER_ON_FIRE"
		_: return "Unknown error"


# NOD
func _gcd(a: int, b: int) -> int:
	while a > 0 and b > 0:
		if a > b:
			a %= b
		else:
			b %= a
	return a + b
