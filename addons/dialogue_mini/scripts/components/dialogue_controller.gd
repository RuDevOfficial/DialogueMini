class_name DialogueController
extends Control
## Contains all the necessary info to output dialogue data, called from DialogueManager.
## [br] All logic related to continuing the dialogue sits here.

signal dialogue_closed(dialogue_entry : StringName) 				## Triggered when the dialogue ends.
signal step_ended(dialogue_entry : StringName, step_index : int) 	## Triggered when a dialogue step ends.
signal step_started(dialogue_entry : StringName, step_index : int) 	## Triggered when a dialogue step starts.

const TIME_PER_CHAR : float = 0.05
const CONTINUE_DIALOGUE_INPUT : String = "select_dialogue"			## Action used to continue a dialogue or select it. Override with your own.

#region Onready Values
# These values need to be overwritten if you plan to use a different dialogue scene
@export var animation_player : AnimationPlayer
@export var dialogue_text : RichTextLabel
#endregion

#region Dynamic Values during Dialogue
var is_active : bool 										## Determines if the dialogue is already being shown.
var finished_step : bool = false 							## Determines if it finished the dialogue

var current_dialogue_step : int = 0 						## Determines which current step we are into the dialogue.
var current_dialogue_entry : DialogueLibraryEntry = null	## Current entry that is being read
var current_step_effect : DialogueEntryEffect = null		## Current effect from the dialogue entry
var close_dialogue_callable : Callable						## Callable given when requesting a dialogue. Will trigger when dialogue ends.

var last_visible_char_amount : int = 0						## Value set in process, determines what's the last character seen.
var current_time : float = 0.0								## Keeps track of the total time spent on a dialogue step.
var total_time : float = 0.0								## Total time set by taking into account TIME_PER_CHAR * character amount per each step.
#endregion

#region Values related to Modifiers
# This contains all dynamic values that DialogueEntryEffects will modify when used.
# If you want to add more, this is the place to do so.

var char_sounds : bool = true 								## Determines per text entry if the char sounds are triggered.
var speed_multiplier : float = 1.0 							## Determines how fast the characters show up per text entry.
var can_instantly_show_text : bool = true 					## Determines if the controller skips and shows all characters when pressing "continue_dialogue".
#endregion

func _ready() -> void:
	animation_player.animation_finished.connect(_try_clear_dialogue)
	set_process(false)

func _input(event: InputEvent) -> void:
	if is_active == false: return
	
	if event.is_action_pressed(CONTINUE_DIALOGUE_INPUT): # Override the action with the one you want the most.
		# We don't want to accidentally get the whole thing in one go on the first frame.
		if dialogue_text.visible_ratio == 0: return
		
		if finished_step == false:
			if can_instantly_show_text == false: return
			
			set_process(false)
			current_time = 0.0
			finished_step = true
			dialogue_text.visible_ratio = 1.0
		else:
			finished_step = false
			_continue_dialogue()

func _process(delta: float) -> void:
	current_time += delta * speed_multiplier
	var characters_shown : int = int(current_time / TIME_PER_CHAR)
	
	if characters_shown != last_visible_char_amount:
		last_visible_char_amount = characters_shown
		dialogue_text.visible_characters = characters_shown
		var index_char : int = clampi(dialogue_text.visible_characters - 1, 0, dialogue_text.text.length() - 1)
		
		if char_sounds == true:
			if index_char >= 0:
				if dialogue_text.text.is_empty() == false:
					if _string_has_only_letters(dialogue_text.text[index_char]):
						#Use your audio manager or something to play the audio here
						pass
	
	if dialogue_text.visible_ratio >= 1.0:
		current_time = 0.0
		finished_step = true
		step_ended.emit(current_dialogue_entry.reference_name, current_dialogue_step)
		set_process(false)

## Clears text and then calls the dialogue window to show up, requires a dialogue resource.
func pop_in(dialogue_entry : DialogueLibraryEntry, callable : Callable = func(): pass) -> void:
	is_active = true
	set_process(true)
	
	_set_start_default_values(dialogue_entry, callable)
	_set_values_per_step()
	_try_emit_step_start()
	_emit_dialogue_step_effects()
	
	animation_player.play("start")

## Ends the dialogue window and clears remaining text when animation finishes. If an optional callable is added it will trigger that method.
func pop_out() -> void:
	
	set_process(false)
	animation_player.play("end")

## Like pop_out but forcibly ends it sooner.
func force_pop_out() -> void:
	# Don't force if there's no current entry anyways.
	if current_dialogue_entry == null: return
	
	_try_trigger_closing_effect()
	
	# Deactivate and reset values
	set_process(false)
	is_active = false
	_reset_values_to_default()
	
	# Finally, reset the animation state.
	animation_player.play("RESET")

## Continues by checking current index, pops out automatically when finishes.
func _continue_dialogue() -> void:
	current_dialogue_step += 1
	if current_dialogue_step >= current_dialogue_entry.steps.size():
		pop_out()
		return
	
	_set_values_per_step()
	_try_emit_step_start()
	_emit_dialogue_step_effects()
	_play_contextual_animation()

## Sets default values when the dialogue starts
func _set_start_default_values(dialogue_entry : DialogueLibraryEntry, callable : Callable) -> void:
	current_dialogue_step = 0
	current_dialogue_entry = dialogue_entry
	close_dialogue_callable = callable

## Tries to trigger the Effect from the current step at the start.
func _try_trigger_step_effects() -> void:
	if current_step_effect != null:
		current_step_effect.trigger(self)

func _set_values_per_step() -> void:
	set_process(true)
	
	current_time = 0
	dialogue_text.visible_ratio = 0
	dialogue_text.visible_characters = 0
	dialogue_text.text = current_dialogue_entry.steps.get(current_dialogue_step).text
	total_time = (dialogue_text.text.length() - 1) * TIME_PER_CHAR
	current_step_effect = current_dialogue_entry.steps.get(current_dialogue_step).effect
	
	char_sounds = true
	speed_multiplier = 1.0
	can_instantly_show_text = true
	
func _emit_dialogue_step_effects() -> void:
	if current_dialogue_step > 0:
		var previous_step : DialogueEntryEffect = current_dialogue_entry.steps.get(current_dialogue_step - 1).effect
		if previous_step != null:
			previous_step.reset(self)
	
	_try_trigger_step_effects()

func _try_emit_step_start() -> void:
	step_started.emit(current_dialogue_entry.reference_name, current_dialogue_step)

func _play_contextual_animation() -> void:
	# Changing anim if the next one is going to go out of bounds
	if current_dialogue_step + 1 >= current_dialogue_entry.text_entries.size():
		animation_player.play("continue_end")
	else:
		animation_player.play("continue_next")
	
func _try_trigger_closing_effect() -> void:
	if current_dialogue_entry.closing_effect != null:
		current_dialogue_entry.closing_effect.reset(self)

func _reset_values_to_default() -> void:
	dialogue_text.text = ""
	current_dialogue_step = 0
	dialogue_text.visible_characters = 0
	dialogue_text.visible_ratio = 0.0
	current_time = 0
	
	set_process(false)
	is_active = false
	
	speed_multiplier = 1.0
	char_sounds = true
	can_instantly_show_text = true
	
	current_dialogue_entry = null

func _try_clear_dialogue(anim_name : StringName) -> void:
	match anim_name:
		&"start":
			if current_dialogue_step + 1 >= current_dialogue_entry.steps.size():
				animation_player.play("continue_end")
			else:
				animation_player.play("continue_next")
		&"end":
			close_dialogue_callable.call()
			dialogue_closed.emit(current_dialogue_entry.reference_name)
			
			_try_trigger_closing_effect()
			_reset_values_to_default()

func _string_has_only_letters(string : String) -> bool:
	var regex = RegEx.create_from_string("[a-zA-Z]")
	var result : RegExMatch = regex.search(string)
	
	if result:
		return true
	else:
		return false
