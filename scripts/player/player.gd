extends CharacterBody2D

const RUN_FRAMES: Array[Texture2D] = [
	preload("res://assets/art/player_runner.svg"),
	preload("res://assets/art/player_runner_step.svg")
]
const FRAME_INTERVAL_SECONDS: float = 0.10

@export var lane_positions: Array[float] = [460.0, 380.0, 300.0]
@export var start_x: float = 300.0
@export var min_x: float = 220.0
@export var max_x: float = 980.0
@export var forward_pixels_per_second: float = 42.0
@export var lane_change_speed: float = 700.0

@onready var body_visual: Sprite2D = $Body

var current_lane: int = 1
var run_time: float = 0.0
var frame_timer: float = 0.0
var frame_index: int = 0

func _ready() -> void:
	add_to_group("player")
	current_lane = clampi(current_lane, 0, lane_positions.size() - 1)
	position = Vector2(start_x, lane_positions[current_lane])
	body_visual.texture = RUN_FRAMES[0]

func _physics_process(delta: float) -> void:
	if GameState.is_game_over or GameState.is_paused:
		body_visual.position.y = 0.0
		body_visual.scale.y = 1.0
		body_visual.texture = RUN_FRAMES[0]
		return

	position.x = clampf(position.x + forward_pixels_per_second * delta, min_x, max_x)
	position.y = move_toward(position.y, lane_positions[current_lane], lane_change_speed * delta)

	run_time += delta
	frame_timer += delta
	if frame_timer >= FRAME_INTERVAL_SECONDS:
		frame_timer = 0.0
		frame_index = (frame_index + 1) % RUN_FRAMES.size()
		body_visual.texture = RUN_FRAMES[frame_index]

	body_visual.position.y = sin(run_time * 14.0) * 2.5
	body_visual.scale.y = 1.0 + sin(run_time * 14.0) * 0.04

func _unhandled_input(event: InputEvent) -> void:
	if GameState.is_game_over or GameState.is_paused:
		return

	if event.is_action_pressed("move_up"):
		current_lane = min(lane_positions.size() - 1, current_lane + 1)
	elif event.is_action_pressed("move_down"):
		current_lane = max(0, current_lane - 1)
