class_name AnimationKeyResource
extends Resource
## Resource class used for the AnimPlayerDialogueReciever.

## All indexes where the animation will be played. Can be a single index or multiple.
## Typing anything lower than 0 will always play on every step if there are no other indexes.
@export var steps : PackedInt32Array 

## Animation name that will be played if the indexes match
@export var key : StringName
