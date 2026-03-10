extends Node2D

@export var good_item_scene: PackedScene
@export var bad_item_scene: PackedScene
@export var spawn_x: float = 1380.0
@export var lane_positions: Array[float] = [460.0, 380.0, 300.0]
@export var initial_spawn_interval: float = 1.0
@export var minimum_spawn_interval: float = 0.45
@export var difficulty_step_seconds: float = 12.0

const GOOD_ITEM_NAMES: Array[String] = ["dinheiro", "DARF", "regularização", "nota em dia"]
const BAD_ITEM_NAMES: Array[String] = ["caixa dois", "offshore suspeita", "recibo frio", "malha fina"]

@onready var spawn_timer: Timer = $ItemSpawner/SpawnTimer

var elapsed_time: float = 0.0
var difficulty_level: int = 0
var game_over_handled: bool = false

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
		if not game_over_handled:
			_handle_game_over()

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

	var lane_index: int = randi_range(0, lane_positions.size() - 1)
	var bad_spawn_probability: float = minf(0.65, 0.45 + float(difficulty_level) * 0.03)
	var spawn_good: bool = randf() > bad_spawn_probability
	var item: Node2D = (good_item_scene.instantiate() if spawn_good else bad_item_scene.instantiate()) as Node2D
	if item == null:
		return

	item.position = Vector2(spawn_x, lane_positions[lane_index])
	add_child(item)
	item.add_to_group("spawned_item")

	if spawn_good and item.has_method("set_item_label_text"):
		item.call("set_item_label_text", GOOD_ITEM_NAMES.pick_random())
	elif not spawn_good and item.has_method("set_item_label_text"):
		item.call("set_item_label_text", BAD_ITEM_NAMES.pick_random())

func _update_difficulty() -> void:
	var target_level: int = int(floor(elapsed_time / difficulty_step_seconds))
	if target_level == difficulty_level:
		return

	difficulty_level = target_level
	spawn_timer.wait_time = maxf(
		minimum_spawn_interval,
		initial_spawn_interval - float(difficulty_level) * 0.06
	)

func _toggle_pause() -> void:
	GameState.is_paused = not GameState.is_paused
	spawn_timer.paused = GameState.is_paused

func _handle_game_over() -> void:
	game_over_handled = true
	spawn_timer.stop()

	var spawned_items: Array[Node] = get_tree().get_nodes_in_group("spawned_item")
	for item in spawned_items:
		if is_instance_valid(item):
			item.queue_free()
