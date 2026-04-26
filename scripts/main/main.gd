extends Node2D

const BG_WIDTH: float = 1280.0

@export var item_scene: PackedScene
@export var pool_size: int = 15

@export var spawn_x: float = 1380.0
@export var lane_positions: Array[float] = [460.0, 380.0, 300.0]
@export var initial_spawn_interval: float = 1.0
@export var minimum_spawn_interval: float = 0.45
@export var difficulty_step_seconds: float = 12.0
@export var far_parallax_speed: float = 16.0
@export var near_parallax_speed: float = 32.0
@export var bad_spawn_probability_base: float = 0.45
@export var bad_spawn_probability_max: float = 0.65
@export var bad_spawn_probability_step: float = 0.03
@export var difficulty_interval_reduction: float = 0.06

# --- Catálogo de itens: adicione ou edite entradas aqui ---
const GOOD_ITEMS: Array[Dictionary] = [
	{label = "dinheiro",      texture = preload("res://assets/art/item_good_tax.svg")},
	{label = "DARF",          texture = preload("res://assets/art/item_good_tax.svg")},
	{label = "regularização", texture = preload("res://assets/art/item_good_tax.svg")},
	{label = "nota em dia",   texture = preload("res://assets/art/item_good_tax.svg")},
]

const BAD_ITEMS: Array[Dictionary] = [
	{label = "maleta suspeita",  texture = preload("res://assets/art/item_bad_tax.png")},
	{label = "imposto surpresa", texture = preload("res://assets/art/item_bad_surprise_tax.png")},
]
# ----------------------------------------------------------

@onready var spawn_timer: Timer = $ItemSpawner/SpawnTimer
@onready var far_a: Sprite2D = $Parallax/FarA
@onready var far_b: Sprite2D = $Parallax/FarB
@onready var near_a: Sprite2D = $Parallax/NearA
@onready var near_b: Sprite2D = $Parallax/NearB
@onready var good_sfx: AudioStreamPlayer = $GoodSfx
@onready var bad_sfx: AudioStreamPlayer = $BadSfx
@onready var game_over_sfx: AudioStreamPlayer = $GameOverSfx

var elapsed_time: float = 0.0
var difficulty_level: int = 0
var game_over_handled: bool = false
var _item_pool: Array[Node2D] = []
var _consecutive_bad: int = 0
var _last_lane: int = -1


func _ready() -> void:
	GameState.reset()
	randomize()

	_init_signal_connections()
	_init_pools()

	spawn_timer.wait_time = initial_spawn_interval
	if not spawn_timer.timeout.is_connected(_on_spawn_timer_timeout):
		spawn_timer.timeout.connect(_on_spawn_timer_timeout)
	spawn_timer.start()

func _init_pools() -> void:
	for i in range(pool_size):
		var item = item_scene.instantiate() as Node2D
		add_child(item)
		item.add_to_group("spawned_item")
		item.call("deactivate")
		_item_pool.append(item)


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

	_update_parallax(delta)

	elapsed_time += delta
	_update_difficulty()
	GameState.tick_passive_chase(delta)

func _on_spawn_timer_timeout() -> void:
	if GameState.is_game_over or GameState.is_paused:
		return

	var lane_index: int = _pick_lane()
	var spawn_good: bool = _pick_item_kind()

	var item: Node2D = _get_item_from_pool(_item_pool)
	if item == null:
		return

	var catalog: Array[Dictionary] = GOOD_ITEMS if spawn_good else BAD_ITEMS
	var entry: Dictionary = catalog[randi() % catalog.size()]
	var kind = 0 if spawn_good else 1  # ItemKind.GOOD / BAD
	item.call("setup", entry.label, entry.texture, kind)
	item.call("reset_state", Vector2(spawn_x, lane_positions[lane_index]))

	_last_lane = lane_index
	_consecutive_bad = 0 if spawn_good else _consecutive_bad + 1

func _pick_lane() -> int:
	var available: Array[int] = []
	for i in range(lane_positions.size()):
		if i != _last_lane:
			available.append(i)
	return available[randi_range(0, available.size() - 1)]

func _pick_item_kind() -> bool:
	if _consecutive_bad >= 2:
		return true
	if GameState.risk_level == "Alto":
		return randf() > 0.25
	var bad_prob: float = minf(bad_spawn_probability_max, bad_spawn_probability_base + float(difficulty_level) * bad_spawn_probability_step)
	return randf() > bad_prob

func _get_item_from_pool(pool: Array[Node2D]) -> Node2D:
	for item in pool:
		if is_instance_valid(item) and not item.get("is_active"):
			return item
	return null


func _update_difficulty() -> void:
	var target_level: int = int(floor(elapsed_time / difficulty_step_seconds))
	if target_level == difficulty_level:
		return

	difficulty_level = target_level
	spawn_timer.wait_time = maxf(
		minimum_spawn_interval,
		initial_spawn_interval - float(difficulty_level) * difficulty_interval_reduction
	)

func _update_parallax(delta: float) -> void:
	_scroll_pair(far_a, far_b, far_parallax_speed, delta)
	_scroll_pair(near_a, near_b, near_parallax_speed, delta)

func _scroll_pair(layer_a: Sprite2D, layer_b: Sprite2D, speed: float, delta: float) -> void:
	layer_a.position.x -= speed * delta
	layer_b.position.x -= speed * delta

	if layer_a.position.x <= -BG_WIDTH / 2.0:
		layer_a.position.x = layer_b.position.x + BG_WIDTH
	if layer_b.position.x <= -BG_WIDTH / 2.0:
		layer_b.position.x = layer_a.position.x + BG_WIDTH

func _toggle_pause() -> void:
	GameState.is_paused = not GameState.is_paused
	spawn_timer.paused = GameState.is_paused

func _handle_game_over() -> void:
	game_over_handled = true
	spawn_timer.stop()

	# Apenas resetamos o comportamento fisico e visao dos itens ativados
	for item in _item_pool:
		if is_instance_valid(item) and item.get("is_active"):
			item.call("deactivate")


func _init_signal_connections() -> void:
	if not GameState.good_item_collected.is_connected(_on_good_item_collected):
		GameState.good_item_collected.connect(_on_good_item_collected)
	if not GameState.bad_item_collected.is_connected(_on_bad_item_collected):
		GameState.bad_item_collected.connect(_on_bad_item_collected)
	if not GameState.game_over_triggered.is_connected(_on_game_over_triggered):
		GameState.game_over_triggered.connect(_on_game_over_triggered)

func _on_good_item_collected() -> void:
	if good_sfx.playing:
		good_sfx.stop()
	good_sfx.play()

func _on_bad_item_collected() -> void:
	if bad_sfx.playing:
		bad_sfx.stop()
	bad_sfx.play()

func _on_game_over_triggered() -> void:
	if game_over_sfx.playing:
		game_over_sfx.stop()
	game_over_sfx.play()
