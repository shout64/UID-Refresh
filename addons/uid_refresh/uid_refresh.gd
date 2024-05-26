@tool
extends EditorPlugin

var tool_name    : String = "UID Refresh"
var log_location : String

func _enter_tree():
  add_tool_menu_item(tool_name, fix_broken_uid)
  # TODO: Prompt with pop-up to enable logging
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
  fix_broken_dependancies()


func check_log_location():
  # If log location changes, update it.
  if ProjectSettings.get_setting("debug/file_logging/log_path") != log_location:
    log_location = ProjectSettings.get_setting("debug/file_logging/log_path")

func fix_broken_dependancies():
  var log = FileAccess.open("user://logs/godot.log", FileAccess.READ)
  while log.eof_reached() == false:
    var content = log.get_line()
    if content.contains("invalid UID: ") == true:
      # Find the affected TSCN file
      var tscn_loc = (content.find(".tscn") - 9)
      var affected_tscn = content.substr(14, tscn_loc)

      # Find invalid UID
      var uid_start = (content.find("invalid UID: ") + 13)
      var uid_end = (content.find(" - using", uid_start) - uid_start)
      var invalid_uid = content.substr(uid_start, uid_end)

      # Find path of asset
      var asset_start = content.find("res://", uid_end)
      var asset_path = content.substr(asset_start, -1)

#TODO: Get UID's needed, will have to search each .import file for correct UID


#TODO: Replace UID
func update_UID():
  #for scene in scenes:
    #var scene = scenes["node"]
    #var file = FileAccess.open("res://")
    #replace is a string function
  pass
