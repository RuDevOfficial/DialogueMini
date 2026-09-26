class_name DialogueEntryNoSkipStepEffect
extends DialogueEntryEffect
## Forces the player to see the entire dialogue without being able to skip the step.

func trigger(dialogue_controller : DialogueController) -> void:
	dialogue_controller.can_instantly_show_text = false

func reset(dialogue_controller : DialogueController) -> void:
	dialogue_controller.can_instantly_show_text = true
