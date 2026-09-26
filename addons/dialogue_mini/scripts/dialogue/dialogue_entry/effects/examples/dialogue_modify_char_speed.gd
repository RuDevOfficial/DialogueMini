class_name CharSpeedModifierEntryEffect
extends DialogueEntryEffect
## Entry effect that modifies the speed of the text.

@export var speed_multiplier : float = 1.0

func trigger(dialogue_controller : DialogueController) -> void:
	dialogue_controller.speed_multiplier = speed_multiplier

func reset(dialogue_controller : DialogueController) -> void:
	dialogue_controller.speed_multiplier = 1.0
