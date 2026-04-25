extends Node2D

const BG_WIDTH: float = 1280.0

@export var good_item_scene: PackedScene
@export var bad_item_scene: PackedScene
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

const GOOD_ITEM_NAMES: Array[String] = ["dinheiro", "DARF", "regularização", "nota em dia"]
const BAD_ITEM_NAMES: Array[String] = ["caixa dois", "offshore suspeita", "recibo frio", "malha fina"]

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
var _good_pool: Array[Node2D] = []
var _bad_pool: Array[Node2D] = []


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
	# Inicializa as duas pools, instanciando e mantendo invisiveis
	for i in range(pool_size):
		var g_item = good_item_scene.instantiate() as Node2D
		add_child(g_item)
		g_item.add_to_group("spawned_item")
		g_item.call("deactivate")
		_good_pool.append(g_item)

		var b_item = bad_item_scene.instantiate() as Node2D
		add_child(b_item)
		b_item.add_to_group("spawned_item")
		b_item.call("deactivate")
		_bad_pool.append(b_item)


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

	var lane_index: int = randi_range(0, lane_positions.size() - 1)
	var bad_spawn_probability: float = minf(bad_spawn_probability_max, bad_spawn_probability_base + float(difficulty_level) * bad_spawn_probability_step)
	var spawn_good: bool = randf() > bad_spawn_probability
	
	var item: Node2D = _get_item_from_pool(_good_pool if spawn_good else _bad_pool)
	if item == null:
		return

	item.call("reset_state", Vector2(spawn_x, lane_positions[lane_index]))

	if spawn_good and item.has_method("set_item_label_text"):
		item.call("set_item_label_text", GOOD_ITEM_NAMES.pick_random())
	elif not spawn_good and item.has_method("set_item_label_text"):
		item.call("set_item_label_text", BAD_ITEM_NAMES.pick_random())

func _get_item_from_pool(pool: Array[Node2D]) -> Node2D:
	for item in pool:
		if is_instance_valid(item) and item.get("is_active") == false:
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
	for item in _good_pool + _bad_pool:
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
