extends CanvasLayer
## Takes care for everything dialogue related, starts dialogues and ends dialogues.
## Contains a simple pop in and out with autocomplete.

## Used to request a dialogue. Force dialogue means it will bruteforce a new dialogue window, closing the previous.
signal request_begin_dialogue(entry : StringName, force_dialogue : bool, callable : Callable)	

signal dialogue_closed(dialogue_entry : StringName) 						## Triggered when the dialogue is closed.
signal dialogue_step_ends(dialogue_entry : StringName, step_index : int) 	## Triggered when a dialogue step ends.
signal dialogue_step_starts(dialogue_entry : StringName, step_index : int) 	## Triggered when a dialogue step starts.

## Sets the default layer on which this manager will sit in, modify if needed.
const DEFAULT_LAYER : int = 8 ## Default layer the dialogue system will be in
## Dialogue library used to look up dialogue entries, modify if needed. (Recommended)
const DIALOGUE_LIBRARY : DialogueLibrary = preload("uid://dy2g6kyhqkvmr") ## Substitute the library entry with another

## Packedscene used for the dialogue window. Overwrite it with your own. Must contain a Control node with the root having "dialogue_controller.gd
var interface_setup : PackedScene = preload("uid://bs2barrqe60u3") 
## Instance of the dialogue controller (interface_setup) created on initialization.
var dialogue_controller : DialogueController = null ## Dialogue Controller created on setup.

var target_callable : Callable ## Method meant to be triggered when the dialogue finishes.

func _init() -> void:
	request_begin_dialogue.connect(_begin_dialogue)

func _ready() -> void:
	dialogue_controller = interface_setup.instantiate()
	add_child(dialogue_controller)
	
	dialogue_controller.dialogue_closed.connect(func(dialogue_entry : StringName): dialogue_closed.emit(dialogue_entry))
	dialogue_controller.step_started.connect(func(dialogue_entry : StringName, step_index : int): dialogue_step_starts.emit(dialogue_entry, step_index))
	dialogue_controller.step_ended.connect(func(dialogue_entry : StringName, step_index : int): dialogue_step_ends.emit(dialogue_entry, step_index))
	
	layer = DEFAULT_LAYER

func is_dialogue_active() -> bool:
	return dialogue_controller.is_active

func _begin_dialogue(key : StringName, forced : bool = false, callable : Callable = func(): pass) -> void:
	# We don't want to trigger it again if it's already active
	if dialogue_controller.is_active == true and forced == false: return
	
	var dialogue_entry : DialogueLibraryEntry = DIALOGUE_LIBRARY.get_dialogue(key)
	if dialogue_entry == null:
		push_error("No dialogue with key %s has been found on the dialogue library." % [key])
		return
	
	dialogue_controller.pop_in(dialogue_entry, callable)

func _end_dialogue() -> void:
	# We don't want to trigger it again if it's already inactive
	if dialogue_controller.is_active == false: return
	
	dialogue_controller.pop_out()

func _force_end_dialogue() -> void:
	dialogue_controller.force_pop_out()
