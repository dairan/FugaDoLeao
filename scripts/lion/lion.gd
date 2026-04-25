extends Node2D

const LION_FRAMES: Array[Texture2D] = [
	preload("res://assets/art/lion_chaser.svg"),
	preload("res://assets/art/lion_chaser_step.svg")
]
const FRAME_INTERVAL_SECONDS: float = 0.14

@export var min_gap: float = 55.0
@export var max_gap: float = 300.0
@export var follow_lerp_speed: float = 4.0

@onready var body_visual: Sprite2D = $Body

var player: Node2D
var frame_timer: float = 0.0
var frame_index: int = 0

# Contract: player node must be in group "player".
func _ready() -> void:
	player = get_tree().get_first_node_in_group("player") as Node2D
	body_visual.texture = LION_FRAMES[0]

func _process(delta: float) -> void:
	if GameState.is_game_over or GameState.is_paused:
		body_visual.texture = LION_FRAMES[0]
		return

	_animate_lion(delta)

	if player == null:
		player = get_tree().get_first_node_in_group("player") as Node2D
		if player == null:
			return

	var distance_ratio: float = clampf(GameState.lion_distance / 260.0, 0.0, 1.0)
	var gap: float = lerpf(min_gap, max_gap, distance_ratio)
	var target_x: float = player.global_position.x - gap
	var target_y: float = player.global_position.y

	global_position.x = lerpf(global_position.x, target_x, follow_lerp_speed * delta)
	global_position.y = lerpf(global_position.y, target_y, follow_lerp_speed * delta)

func _animate_lion(delta: float) -> void:
	frame_timer += delta
	if frame_timer >= FRAME_INTERVAL_SECONDS:
		frame_timer = 0.0
		frame_index = (frame_index + 1) % LION_FRAMES.size()
		body_visual.texture = LION_FRAMES[frame_index]
