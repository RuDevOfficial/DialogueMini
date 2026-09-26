class_name GrabFocusStart
extends Node
## Component that allows a control node to be focused first on ready.

func _ready() -> void:
	var control : Control = get_parent()
	if control == null: return
	
	control.grab_focus()
