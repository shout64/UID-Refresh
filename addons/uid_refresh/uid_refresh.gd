@tool
extends EditorPlugin

var tool_name    : String = "UID Refresh"
var log_location : String

func _enter_tree():
  add_tool_menu_item(tool_name, fix_broken_uid)
  enable_logging()

func _exit_tree():
  remove_tool_menu_item(tool_name)

func fix_broken_uid():
  if ProjectSettings.get_setting("debug/file_logging/enable_file_logging") == false:
    enable_logging()
    print("Please re-run UID Refresh.")
  else:
    get_log_location()
    fix_broken_dependencies()

func get_log_location():
  # If log location changes, update it.
  
  #### Default log location user://logs/godot.log
# Windows: %APPDATA%\Godot\app_userdata\[project_name]
# macOS: ~/Library/Application Support/Godot/app_userdata/[project_name]
# Linux: ~/.local/share/godot/app_userdata/[project_name]

  if ProjectSettings.get_setting("debug/file_logging/log_path") != log_location:
    log_location = ProjectSettings.get_setting("debug/file_logging/log_path")

func enable_logging():
  if ProjectSettings.get_setting("debug/file_logging/enable_file_logging") == false:
    ProjectSettings.set_setting("debug/file_logging/enable_file_logging", true)
    print("File logging enabled")


func fix_broken_dependencies():
  # Open the error log
  if FileAccess.file_exists(log_location) == true:
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
        var tscn             = FileAccess.open(affected_tscn, FileAccess.READ)
        var tscn_content_old = tscn.get_as_text()
        tscn.close()
        # Fix the mismatched UID, and don't try to overwrite if it's already been fixed
        if tscn_content_old.contains(invalid_uid) == true:
          var tscn_content_new = tscn_content_old.replacen(invalid_uid, correct_asset_UID)
          tscn = FileAccess.open(affected_tscn, FileAccess.WRITE)
          tscn.store_string(tscn_content_new)
          tscn.close()
          print("Fixed broken UID in the TSCN " + affected_tscn + " for asset " + asset_path)
        else:
          print("First broken dependency is already fixed.")
          print("Run game to get a new copy of the error log.")
      
    log.close()
  else:
    print("No log file to check. Please run your game and exit to generate a new log file.")
