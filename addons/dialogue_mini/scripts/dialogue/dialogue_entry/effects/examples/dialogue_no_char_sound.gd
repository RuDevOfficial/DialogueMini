class_name DialogueNoCharSoundEffect
extends DialogueEntryEffect
## Effect that makes sure the char sound doesn't get played in that line.

func trigger(dialogue_controller : DialogueController) -> void:
	dialogue_controller.char_sounds = false

func reset(dialogue_controller : DialogueController) -> void:
	dialogue_controller.char_sounds = true
