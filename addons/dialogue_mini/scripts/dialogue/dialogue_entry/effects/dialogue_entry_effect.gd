@abstract
class_name DialogueEntryEffect
extends Resource
## Triggers an effect type by step (text entries).

## Triggers during the dialogue entry. Used to set values.
@abstract func trigger(dialogue_controller : DialogueController) -> void

## Triggers before the next dialogue entry plays, used to reset values.
func reset(dialogue_controller : DialogueController) -> void: pass
