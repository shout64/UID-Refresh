@tool
extends EditorPlugin

var tool_name    : String = "UID Refresh"
var scenes    : Dictionary
var log_location : String

func _enter_tree():
  add_tool_menu_item(tool_name, fix_broken_uid)
  if ProjectSettings.get_setting("debug/file_logging/enable_file_logging") == false:
    ProjectSettings.set_setting("debug/file_logging/enable_file_logging", true)

#### Default log location user://logs/godot.log
# Windows: %APPDATA%\Godot\app_userdata\[project_name]
# macOS: ~/Library/Application Support/Godot/app_userdata/[project_name]
# Linux: ~/.local/share/godot/app_userdata/[project_name]
  log_location = ProjectSettings.get_setting("debug/file_logging/log_path")

func _exit_tree():
  remove_tool_menu_item(tool_name)

func fix_broken_uid():
  check_log_location()
  get_broken_dependancies()


func check_log_location():
  if ProjectSettings.get_setting("debug/file_logging/log_path") != log_location:
    log_location = ProjectSettings.get_setting("debug/file_logging/log_path")

# TODO: Parse the log and get the effected TSCN, bad UID, and path of assets we need UIDs for
func get_broken_dependancies():
  var log = FileAccess.open("user://logs/godot.log", FileAccess.READ)
  var content = log.get_as_text()
  print(content)
  
  
#TODO: Get UID's needed, will have to search each .import file for correct UID

#TODO: Replace UID
func update_UID():
  #for scene in scenes:
    #var scene = scenes["node"]
    #var file = FileAccess.open("res://")
  pass
