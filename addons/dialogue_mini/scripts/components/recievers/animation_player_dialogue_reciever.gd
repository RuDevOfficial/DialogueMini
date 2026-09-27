class_name AnimPlayerDialogueReciever
extends DialogueReciever
## Node that uses the Dialogue Manager's step emitter feature to do specific animations.
## [br]Must be placed as a child of the AnimationPlayer

## Determines if the dialogue reciever uses the same anim for the start and end for each step.
@export var is_simple : bool = true:
	set(value):
		is_simple = value
		notify_property_list_changed()

# Necessary references
var animation_player : AnimationPlayer

# Shared Parameters
@export var close_dialogue_animation_key : StringName	## Animation name when the dialogue interface closes

# Simple Parameters
@export_group("Simple")
@export var start_step_animation_key : StringName		## Animation name when every single dialogue step starts
@export var end_step_animation_key : StringName			## Animation name when every single dialogue step ends

# Advanced Parameters
@export_group("Advanced")
@export var start_step_animation_key_array : Array[AnimationKeyResource] = []		## Animations played per each step started and in which steps. [br]Each KeyResource contains a list of step indexes and the animation key.
@export var end_step_animation_keys_array : Array[AnimationKeyResource] = []		## Animations played per each step ended and in which steps. [br]Each KeyResource contains a list of step indexes and the animation key.

func _ready() -> void:
	_check_for_queue_free()
	
	# Check if the parent is even an animation player.
	if get_parent() is not AnimationPlayer: 
		push_error("A AnimPlayerDialogueReciever (%s) is being set as a child of %s. But the parent is not an AnimationPlayer" % [name, get_parent().name])
		return
	
	animation_player = get_parent()

## Checks if this node should be removed if certain criteria is met.
func _check_for_queue_free() -> void:
	if compared_key.is_empty():
		queue_free()
		return
	
	if is_simple == true and start_step_animation_key.is_empty() and end_step_animation_key.is_empty():
		queue_free()
		return
	
	if is_simple == false and start_step_animation_key_array.is_empty() and end_step_animation_keys_array.is_empty():
		queue_free()
		return

## Plays an animation from AnimationPlayer every time a dialogue step starts.
func _on_start_step(entry : StringName, step : int) -> void:
	if compared_key != entry: return
	if animation_player == null: return
	
	match is_simple:
		true:
			if start_step_animation_key.is_empty(): 
				animation_player.stop()
			else:
				animation_player.play(start_step_animation_key)
		false:
			animation_player.stop()
			
			for resource : AnimationKeyResource in start_step_animation_key_array:
				if resource.steps.has(step):
					animation_player.play(resource.key)
					break


## Plays an animation from AnimationPlayer every time a dialogue step ends.
func _on_end_step(entry : StringName, step : int) -> void:
	if compared_key != entry: return
	if animation_player == null: return
	
	match is_simple:
		true:
			if end_step_animation_key.is_empty(): 
				animation_player.stop()
			else:
				animation_player.play(end_step_animation_key)
		false:
			animation_player.stop()
			
			for resource : AnimationKeyResource in end_step_animation_keys_array:
				if resource.steps.has(step):
					animation_player.play(resource.key)
					break

## Plays an animation from AnimationPlayer every time a dialogue step ends.
func _on_close_dialogue(entry : StringName) -> void:
	if compared_key != entry: return
	if animation_player == null: return
	
	if close_dialogue_animation_key.is_empty(): 
		animation_player.stop()
	else:
		animation_player.play(entry)
