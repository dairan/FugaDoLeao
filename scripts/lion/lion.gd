extends Node2D

@export var min_gap: float = 55.0
@export var max_gap: float = 300.0
@export var follow_lerp_speed: float = 4.0

var player: Node2D

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player") as Node2D

func _process(delta: float) -> void:
	if GameState.is_game_over or GameState.is_paused:
		return

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
