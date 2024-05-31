@tool
extends EditorPlugin

var tool_name    : String = "UID Refresh"
var log_location : String

func _enter_tree():
  add_tool_menu_item(tool_name, fix_broken_uid)
  # TODO: Prompt with pop-up to enable logging
  if ProjectSettings.get_setting("debug/file_logging/enable_file_logging") == false:
    ProjectSettings.set_setting("debug/file_logging/enable_file_logging", true)

func _exit_tree():
  remove_tool_menu_item(tool_name)

func fix_broken_uid():
  get_log_location()
  fix_broken_dependancies()


func get_log_location():
  # If log location changes, update it.
  
  #### Default log location user://logs/godot.log
# Windows: %APPDATA%\Godot\app_userdata\[project_name]
# macOS: ~/Library/Application Support/Godot/app_userdata/[project_name]
# Linux: ~/.local/share/godot/app_userdata/[project_name]

  if ProjectSettings.get_setting("debug/file_logging/log_path") != log_location:
    log_location = ProjectSettings.get_setting("debug/file_logging/log_path")

func fix_broken_dependancies():
  # Open the error log
  var log = FileAccess.open(log_location, FileAccess.READ)
  while log.eof_reached() == false:
    var content = log.get_line()
    if content.contains("invalid UID: ") == true:
      # Find the affected TSCN file
      var tscn_loc      = (content.find(".tscn") - 9)
      var affected_tscn = content.substr(14, tscn_loc)

      # Find invalid UID
      var uid_start   = (content.find("invalid UID: ") + 13)
      var uid_end     = (content.find(" - using", uid_start) - uid_start)
      var invalid_uid = content.substr(uid_start, uid_end)

      # Find path of asset
      var asset_start = content.find("res://", uid_end)
      var asset_path  = content.substr(asset_start, -1)
      
      # Get correct UID for assets
      var asset_UID_text    = ResourceLoader.get_resource_uid(asset_path)
      var correct_asset_UID = ResourceUID.id_to_text(asset_UID_text)

      # Open affected TSCN
      var tscn             = FileAccess.open(affected_tscn, FileAccess.READ_WRITE)
      var tscn_content_old = tscn.get_as_text()
      
      # Fix the mismatched UID, and don't try to overwrite if it's already been fixed
      if tscn_content_old.contains(invalid_uid) == true:
        var tscn_content_new = tscn_content_old.replacen(invalid_uid, correct_asset_UID)
        tscn.store_string(tscn_content_new)
        print("Fixed broken UID for " + asset_path + " in the TSCN " + affected_tscn)
      else:
        print("Broken dependancy is already fixed.")
      tscn.close()
      
  log.close()
