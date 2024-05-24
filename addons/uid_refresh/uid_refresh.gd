@tool
extends EditorPlugin

var tool_name : String = "UID Refresh"
var scene_uid : Dictionary

func _enter_tree():
  add_tool_menu_item(tool_name, callable)


func _exit_tree():
  remove_tool_menu_item(tool_name)

func get_uid():
  FileAccess.open("user://logs/godot.log", FileAccess.READ)

func callable():
  var scenes = DirAccess.open("res://")
  #for file in FileAccess.get_hidden_attribute()
