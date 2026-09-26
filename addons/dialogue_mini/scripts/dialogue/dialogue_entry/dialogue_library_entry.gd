class_name DialogueLibraryEntry
extends Resource
## Dialogue entry that contains all necessary information for the dialogue manager to make sense of it.

@export var reference_name : StringName = "none" 		## Reference name used to determine a dialogue, used for other nodes in the scene to subscribe to and do actions depending on the step.
@export var steps : Array[DialogueStep]					## Amount of steps a dialogue has, each step has a text and effect.
@export var closing_effect : DialogueEntryEffect		## Effect triggered after dialogue finishes going down. (closing)

func has_multiple_entries() -> bool:
	return steps.size() > 1
