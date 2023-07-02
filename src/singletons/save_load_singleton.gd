extends Node

const SETTINGS_FILENAME := "user_settings.cfg"
const DATA_FILENAME := "player.dat"
const USER_DATA_PREFIX := "user://"
var settings_file_path: String = USER_DATA_PREFIX + SETTINGS_FILENAME
var data_file_path: String = USER_DATA_PREFIX + DATA_FILENAME


#func _ready() -> void:
#	print_debug(OS.get_user_data_dir())


func create_empty_settings_file(file: ConfigFile):
	write_settings_to_file(Global.DEFAULT_SETTINGS, file)
	var error: Error = file.save(settings_file_path)
	if error != OK:
		print_debug(Global.parse_error(error))


func create_empty_data_file(file: FileAccess):
	file = FileAccess.open(data_file_path, FileAccess.WRITE_READ)
	return file


func write_settings_to_file(settings: Dictionary, file: ConfigFile):
	for settings_section in (settings.keys() as Array[String]):
		for setting_name in (settings.get(settings_section).keys() as Array[String]):
			var value = settings.get(settings_section).get(setting_name)
			file.set_value(settings_section, setting_name, value)


func load_settings() -> Dictionary:
	var settings: Dictionary = {}
	var file := ConfigFile.new()
	var error: Error = file.load(settings_file_path)
	if error != OK or file.get_sections().is_empty():
		create_empty_settings_file(file)
	for settings_section in (file.get_sections() as PackedStringArray):
		settings[settings_section] = {}
		for setting_name in (file.get_section_keys(settings_section) as PackedStringArray):
			settings[settings_section][setting_name] = file.get_value(settings_section, setting_name)
	
	return settings


func load_data():
	var data: Dictionary = {}
	var file := FileAccess.open(data_file_path, FileAccess.READ)
	if FileAccess.get_open_error() != OK:
		create_empty_data_file(file)
	
	# process somehow here


func save_settings(settings: Dictionary):
	var file := ConfigFile.new()
	var error: Error = file.load(settings_file_path)
	assert(error == OK)
	write_settings_to_file(settings, file)
	file.save(settings_file_path)


func save_data():
	pass
