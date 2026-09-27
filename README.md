<p align="center">
  <img src="https://github.com/RuDevOfficial/DialogueMini/blob/main/addons/dialogue_mini/github_page_assets/title.png?raw=true" width="400" alt="CastleCopya logo">
</p>

#### A simple narration system for linear dialogues or interactables.

>**🛈 Supported Godot Engine:**  **4.7.2**

This addon adds a simple dialogue manager system, dialogue controller, dialogue library and other related resources for you to use!

## Installation

1. Download the release .zip file.
2. Extract its contents inside the res folder

## Class Information
### Nodes
- **DialogueManager**: Autoload, handles dialogue requests.
- **DialogueController**: Instanciated inside *DialogueManager*, manages writting text on the interface, step emitting and effects.

### Resources
- **DialogueLibrary**: Resource that contains all dialogues available, and are accessed through StringName keys.
- **DialogueLibraryEntry**: Resource that contains a dialogue entry, contains a *reference name* (used by the example class *AnimPlayerDialogueReciever*) and an array of *DialogueStep*.
- **DialogueStep**: Resource used to contain static data for dialogue entries, contains the text shown and a *DialogueEntryEffect*
- **DialogueEntryEffect**: Effects per dialogue step meant to be triggered in order to change properties of the *DialogueController*, such as character speed or blocking autofill.

## Setting up an Interface
In order to set up your own interface in order to use this addon you need to:
1. Create your own dialogue library on a different folder.
2.  On **dialogue_manager.gd**, overwrite the "DIALOGUE_LIBRARY" constant by changing the UID (unique identifier) with your new dialogue library UID (accessed by right clicking the resource and copying the UID).
3. Make a new interface (root must be a Control node) and assign the **dialogue_controller.gd** script to it. Make sure to have an *AnimationPlayer* and *RichTextLabel* nodes added in the inspector. (Or modify the existing **dialogue_controller.tscn** scene)
4. If you made a new interface, assign its UID to the INTERFACE_PACKED_SCENE constant in **DialogueManager**.
5. work in progress
5. Make a new DialogueLibraryEntry, add a new DialogueStep and save it to disk. (You can find how to write on them with the **example_dialogue_library.tres** resource )
6. Call **DialogueManager**.request_begin_dialogue(entry : **StringName**, force_dialogue : **bool**, callable : **Callable**)

## Featured Games using DialogueMini
![GoldVestigation](https://img.itch.zone/aW1hZ2UvNTAwMDUwNS8zMDEyMjQxMi5naWY=/original/9Rd6Fy.gif)
[Goldvestigation](https://ru-dev-official.itch.io/goldvestigation)
