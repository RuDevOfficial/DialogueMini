class_name MultipleDialogueEntryEffect
extends DialogueEntryEffect

@export var effects : Array[DialogueEntryEffect]

func trigger(dialogue_controller : DialogueController) -> void:
	for effect : DialogueEntryEffect in effects:
		effect.trigger(dialogue_controller)

func reset(dialogue_controller : DialogueController) -> void:
	for effect : DialogueEntryEffect in effects:
		effect.reset(dialogue_controller)
