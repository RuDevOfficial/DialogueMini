class_name DebugDialogueItemList
extends ItemList
## ItemList that contains all dialogue entries and allows to start new dialogues.

func _ready() -> void:
	item_clicked.connect(_dialogue_selected)
	
	for key : StringName in DialogueManager.DIALOGUE_LIBRARY.contents:
		self.add_item(key)

func _dialogue_selected(index : int, _position : Vector2, mouse_index : int) -> void:
	if mouse_index != 1: return
	
	var text : StringName = self.get_item_text(index)
	
	var force_dialogue : bool = true
	DialogueManager.request_begin_dialogue.emit(text, force_dialogue)
