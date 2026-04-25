extends Control

@export var game_scene_path: String = "res://scenes/main/Main.tscn"

@onready var start_button: Button = $CenterContainer/VBoxContainer/StartButton
@onready var quit_button: Button = $CenterContainer/VBoxContainer/QuitButton

func _ready() -> void:
	if not start_button.pressed.is_connected(_on_start_pressed):
		start_button.pressed.connect(_on_start_pressed)
	if not quit_button.pressed.is_connected(_on_quit_pressed):
		quit_button.pressed.connect(_on_quit_pressed)

	if OS.has_feature("web"):
		quit_button.visible = false

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("start_game") or event.is_action_pressed("restart_game"):
		_on_start_pressed()

func _on_start_pressed() -> void:
	get_tree().change_scene_to_file(game_scene_path)

func _on_quit_pressed() -> void:
	get_tree().quit()
