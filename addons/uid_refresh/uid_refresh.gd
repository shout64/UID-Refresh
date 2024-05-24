@tool
extends EditorPlugin

var tool_name : String = "UID Refresh"
var scene_uid : Dictionary

func _enter_tree():
  add_tool_menu_item(tool_name, fix_broken_uid())

func _exit_tree():
  remove_tool_menu_item(tool_name)


func fix_broken_uid():
  #Call each function step
  pass

#Individual Functions
# TODO: Turn on debugger logging and use default logging location
func enable_logging():
  pass

# TODO: Parse the log and get bad UID, and path of assets we need UIDs for
func get_broken_dependancies():
  FileAccess.open("user://logs/godot.log", FileAccess.READ)
  
#TODO: Get UID's needed

#TODO: Replace UID
func update_UID():
  var scenes = DirAccess.open("res://")
  #for file in FileAccess.get_hidden_attribute()
