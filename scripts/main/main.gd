extends Node2D

@export var good_item_scene: PackedScene
@export var bad_item_scene: PackedScene
@export var spawn_x: float = 1380.0
@export var lane_positions := [460.0, 380.0, 300.0]
@export var initial_spawn_interval: float = 1.0
@export var minimum_spawn_interval: float = 0.45
@export var difficulty_step_seconds: float = 12.0

const GOOD_ITEM_NAMES := ["dinheiro", "DARF", "regularização", "nota em dia"]
const BAD_ITEM_NAMES := ["caixa dois", "offshore suspeita", "recibo frio", "malha fina"]

@onready var spawn_timer: Timer = $ItemSpawner/SpawnTimer

var elapsed_time: float = 0.0
var difficulty_level: int = 0

func _ready() -> void:
	GameState.reset()
	randomize()
	spawn_timer.wait_time = initial_spawn_interval
	if not spawn_timer.timeout.is_connected(_on_spawn_timer_timeout):
		spawn_timer.timeout.connect(_on_spawn_timer_timeout)
	spawn_timer.start()

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("pause_game") and not GameState.is_game_over:
		_toggle_pause()

	if GameState.is_game_over:
		if Input.is_action_just_pressed("restart_game"):
			get_tree().reload_current_scene()
		return

	if GameState.is_paused:
		return

	elapsed_time += delta
	_update_difficulty()
	GameState.tick_passive_chase(delta)

func _on_spawn_timer_timeout() -> void:
	if GameState.is_game_over or GameState.is_paused:
		return

	var lane_index := randi_range(0, lane_positions.size() - 1)
	var bad_spawn_probability := min(0.65, 0.45 + difficulty_level * 0.03)
	var spawn_good := randf() > bad_spawn_probability
	var item = good_item_scene.instantiate() if spawn_good else bad_item_scene.instantiate()

	item.position = Vector2(spawn_x, lane_positions[lane_index])
	if spawn_good and item.has_method("set_item_label_text"):
		item.set_item_label_text(GOOD_ITEM_NAMES.pick_random())
	elif not spawn_good and item.has_method("set_item_label_text"):
		item.set_item_label_text(BAD_ITEM_NAMES.pick_random())

	add_child(item)

func _update_difficulty() -> void:
	var target_level := int(floor(elapsed_time / difficulty_step_seconds))
	if target_level == difficulty_level:
		return

	difficulty_level = target_level
	spawn_timer.wait_time = max(
		minimum_spawn_interval,
		initial_spawn_interval - difficulty_level * 0.06
	)

func _toggle_pause() -> void:
	GameState.is_paused = not GameState.is_paused
	spawn_timer.paused = GameState.is_paused
