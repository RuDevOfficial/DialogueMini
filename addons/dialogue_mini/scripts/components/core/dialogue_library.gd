@tool
class_name DialogueLibrary
extends Resource
## Contains a library of all dialogues in the game.
## [br]There can only be one in the entire Godot Project.

@export_tool_button("Update Entries", "Callable") var update_entries = _update_entries
@export var library_entries_path : String								## Where are the entries located in your project?
@export var contents : Dictionary[StringName, DialogueLibraryEntry]		## All dialogue entries.

func _update_entries() -> void:
	contents.clear()
	
	var dir := DirAccess.open(library_entries_path)
	if dir == null: return
	dir.list_dir_begin()
	for file: String in dir.get_files():
		var resource : DialogueLibraryEntry = load(dir.get_current_dir() + "/" + file)
		contents.get_or_add(file.trim_suffix(".tres"), resource)

func get_dialogue(key : StringName) -> DialogueLibraryEntry:
	return contents.get(key)
