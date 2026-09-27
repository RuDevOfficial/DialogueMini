@abstract
class_name DialogueReciever
extends Node
## Base class used for other DialogueRecievers.

## Key that is used to compare with the current dialogue, if the key matches the settings in this node will be applied.
@export var compared_key : StringName = &""

func _init() -> void:
	DialogueManager.dialogue_step_starts.connect(_on_start_step)
	DialogueManager.dialogue_step_ends.connect(_on_end_step)
	DialogueManager.dialogue_closed.connect(_on_close_dialogue)

## Method executed every time a dialogue step starts.
@abstract func _on_start_step(entry : StringName, step : int) -> void

## Method executed every time a dialogue step ends.
@abstract func _on_end_step(entry : StringName, step : int) -> void

## Method executed every time a dialogue step ends.
@abstract func _on_close_dialogue(entry : StringName) -> void
