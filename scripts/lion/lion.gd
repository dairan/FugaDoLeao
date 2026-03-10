extends Node2D

@export var min_x: float = 80.0
@export var max_x: float = 320.0

func _process(delta: float) -> void:
	if GameState.is_game_over or GameState.is_paused:
		return

	var distance_ratio := clamp(GameState.lion_distance / 240.0, 0.0, 1.0)
	var target_x := lerp(max_x, min_x, distance_ratio)
	position.x = lerp(position.x, target_x, 4.0 * delta)
