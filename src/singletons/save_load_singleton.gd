## This singleton manages filesystem manupilations: saving/loading player's data and settings.
extends Node

const _SETTINGS_FILENAME := "user_settings.cfg"
const _DATA_FILENAME := "player.dat"
const _USER_DATA_PREFIX := "user://"
var _settings_file_path: String = _USER_DATA_PREFIX + _SETTINGS_FILENAME
var _data_file_path: String = _USER_DATA_PREFIX + _DATA_FILENAME


#func _ready() -> void:
#	print_debug(OS.get_user_data_dir())

## Creates empty settings file of class ConfigFile with Global.DEFAULT_SETTINGS. Prints error if occured.
func create_empty_settings_file(file: ConfigFile):
	write_settings_to_file(Global.DEFAULT_SETTINGS, file)
	var error: Error = file.save(_settings_file_path)
	if error != OK:
		print_debug(Global.parse_error(error))

## Creates empty data file of class FileAccess. Prints error if occured.
func create_empty_data_file(file: FileAccess):
	file = FileAccess.open(_data_file_path, FileAccess.WRITE_READ)
	var error: Error = FileAccess.get_open_error()
	if error != OK:
		print_debug(Global.parse_error(error))
	file.flush()
	return file

## Writes settings to file.
func write_settings_to_file(settings: Dictionary, file: ConfigFile):
	for settings_section in settings.keys() as Array[String]:
		for setting_name in settings.get(settings_section).keys() as Array[String]:
			var value = settings.get(settings_section).get(setting_name)
			file.set_value(settings_section, setting_name, value)

## Returns settings as Disctionary from file at user data path. If error occured or the file is empty, creates new one and proceeds.
func load_settings() -> Dictionary:
	var settings: Dictionary = {}
	var file := ConfigFile.new()
	var error: Error = file.load(_settings_file_path)
	if error != OK or file.get_sections().is_empty():
		create_empty_settings_file(file)
	for settings_section in (file.get_sections() as PackedStringArray):
		settings[settings_section] = {}
		for setting_name in (file.get_section_keys(settings_section) as PackedStringArray):
			settings[settings_section][setting_name] = file.get_value(settings_section, setting_name)
	
	return settings

## WIP. Returns player data as Dictionary from file at user data path. If error occured, ???.
func load_data():
#	var data: Dictionary = {}
	var file := FileAccess.open(_data_file_path, FileAccess.READ)
	if FileAccess.get_open_error() != OK:
		file.close()
		create_empty_data_file(file)
	# process somehow here
	file.close()

## Saves settings to file at user data path. 
func save_settings(settings: Dictionary):
	var file := ConfigFile.new()
	var error: Error = file.load(_settings_file_path)
	assert(error == OK)
	write_settings_to_file(settings, file)
	file.save(_settings_file_path)

## WIP.
func save_data():
	pass


func erase_settings():
	var file := ConfigFile.new()
	var error: Error = file.load(_settings_file_path)
	if error == OK:
		file.clear()
		file.save(_settings_file_path)
