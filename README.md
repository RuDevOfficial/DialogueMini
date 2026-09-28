<p align="center">
  <img src="https://github.com/RuDevOfficial/DialogueMini/blob/main/addons/dialogue_mini/github_page_assets/title.png?raw=true" width="400" alt="CastleCopya logo">
</p>

#### A simple narration system for linear dialogues or interactables.

>**🛈 Supported Godot Engine:**  **4.7.2**

This addon adds a simple scene agnostic dialogue manager system, dialogue controller, dialogue library and other related resources for you to use!

## Installation

1. Download the release .zip file.
2. Extract its contents inside the res folder
3. Make the `DialogueManager` an Autoload/Global.

## Class Information
### Nodes
- **DialogueManager**: Autoload, handles dialogue requests.
- **DialogueController**: Instanciated inside *DialogueManager*, manages writting text on the interface, step emitting and effects.
- **DialogueReciever**: Subscribes to the `dialogue_step_starts`, `dialogue_step_ends` and `dialogue_closed` signals and executes logic every time they fire.

### Resources
- **DialogueLibrary**: Resource that contains all dialogues available, and are accessed through StringName keys.
- **DialogueLibraryEntry**: Resource that contains a dialogue entry, contains a *reference name* (used by the example class *AnimPlayerDialogueReciever*) and an array of *DialogueStep*.
- **DialogueStep**: Resource used to contain static data for dialogue entries, contains the text shown and a *DialogueEntryEffect*
- **DialogueEntryEffect**: Effects per dialogue step meant to be triggered in order to change properties of the *DialogueController*, such as character speed or blocking autofill.

## Tutorials

<details>
<summary>Making up an Interface</summary>
<br>

1. Create a new User Interface scene and name it something like `dialogue_interface.tscn`
2. Assign the `dialogue_controller.gd` script on the root node
3. Create at least 2 children in the node hierarchy: An AnimationPlayer and a RichTextLabel and assign them via the Editor
4. Make 4 specific animations: `start`, `end`, `continue_next` (When there's another text after the current) and `continue_end` (when it's the last dialogue text).
5. Go to `dialogue_manager.gd` and overwrite `INTERFACE_PACKED_SCENE`'s value with this new UID
6. Now this interface will be used instead of the default.

</details>

<details>
<summary>Making up a Dialogue Library</summary>
<br>

1. Make a folder for the dialogues
2. Right click it and create a new DialogueLibrary resource
3. Copy the UID of the new resource you created and overwrite `dialogue_manager.gd`'s `DIALOGUE_LIBRARY` value with this new UID
4. Make a folder for the dialogue entries (preferably inside the dialogues folder in the previous section)
5. Copy the folder path and paste it on the "Library Entries Path" parameter

</details>

<details>
<summary>Adding a new Dialogue Entry</summary>
<br>

1. Right click on the dialogue entries folder created in the previous section and create a new resource of type `DialogueLibraryEntry`
2. Select this new resource and assign a new reference name (sent by the signals `dialogue_step_starts`, `dialogue_step_ends` and `dialogue_closed` from `DialogueManager` used by `DialogueRecievers`)
3. Create a new step by opening the `steps` value in the editor and create a new `DialogueStep`
4. Type the text you want to show and add any effects you might want (you can leave it empty)

</details>

<details>
<summary>Making a new DialogueEffect</summary>

<br>

1. Create a new script and inherit the `DialogueEffect` class
2. Override the `trigger` method always, only override the `reset` method if your effect changes values of the `DialogueController`
3. When making a new `DialogueStep`, you can now choose your new effect!

</details>

<details>
<summary>Making a new Dialogue Reciever</summary>

<br>

1. Create a new script and inherit the `DialogueReciever` class
2. Override all methods: `_on_start_step`, `_on_end_step` and `_on_close_dialogue`

</details>

## Featured Games using DialogueMini
[Goldvestigation](https://ru-dev-official.itch.io/goldvestigation)

![GoldVestigation](https://img.itch.zone/aW1hZ2UvNTAwMDUwNS8zMDEyMjQxMi5naWY=/original/9Rd6Fy.gif)

