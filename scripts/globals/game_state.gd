extends Node

signal good_item_collected
signal bad_item_collected
signal game_over_triggered

const BASE_SPEED: float = 320.0              # px/s de movimento dos itens
const START_DISTANCE: float = 220.0          # distancia inicial leao-jogador (px)
const MAX_DISTANCE: float = 9999.0           # teto para clampf; sem limite pratico
const PASSIVE_DISTANCE_DRAIN: float = 14.0   # px/s que o leao avanca passivamente
const GOOD_DISTANCE_BONUS_BASE: float = 36.0 # bonus de distancia base por item bom
const BAD_DISTANCE_PENALTY: float = 46.0     # penalidade de distancia por item ruim
const COMBO_WINDOW_SECONDS: float = 2.2      # janela em segundos para manter combo

var score: int = 0
var speed: float = BASE_SPEED
var debt: int = 0
var lion_distance: float = START_DISTANCE
var risk_level: String = "Médio"
var combo_count: int = 0
var combo_multiplier: float = 1.0
var combo_timer: float = 0.0
var is_paused: bool = false
var is_game_over: bool = false
var game_over_notified: bool = false

func reset() -> void:
	score = 0
	speed = BASE_SPEED
	debt = 0
	lion_distance = START_DISTANCE
	risk_level = "Médio"
	combo_count = 0
	combo_multiplier = 1.0
	combo_timer = 0.0
	is_paused = false
	is_game_over = false
	game_over_notified = false

func apply_good_tax_pickup() -> void:
	if is_game_over:
		return

	combo_count += 1
	combo_timer = COMBO_WINDOW_SECONDS
	combo_multiplier = minf(3.0, 1.0 + float(combo_count - 1) * 0.15)

	var score_gain: int = int(round(10.0 * combo_multiplier))
	score += score_gain

	var distance_gain: float = GOOD_DISTANCE_BONUS_BASE + float(combo_count) * 2.0
	lion_distance = clampf(lion_distance + distance_gain, 0.0, MAX_DISTANCE)

	debt = max(0, debt - 55 - combo_count * 2)
	_update_risk()
	emit_signal("good_item_collected")

func apply_bad_tax_event() -> void:
	if is_game_over:
		return

	score = max(0, score - 8)
	lion_distance = clampf(lion_distance - BAD_DISTANCE_PENALTY, 0.0, MAX_DISTANCE)
	debt += 100

	combo_count = 0
	combo_multiplier = 1.0
	combo_timer = 0.0

	_update_risk()
	emit_signal("bad_item_collected")
	if lion_distance <= 0.0:
		_set_game_over()

func tick_passive_chase(delta: float) -> void:
	if is_game_over or is_paused:
		return

	if combo_timer > 0.0:
		combo_timer = maxf(0.0, combo_timer - delta)
		if combo_timer <= 0.0:
			combo_count = 0
			combo_multiplier = 1.0

	lion_distance = clampf(lion_distance - PASSIVE_DISTANCE_DRAIN * delta, 0.0, MAX_DISTANCE)

	_update_risk()
	if lion_distance <= 0.0:
		_set_game_over()

func _set_game_over() -> void:
	if is_game_over:
		return

	is_game_over = true
	if not game_over_notified:
		game_over_notified = true
		emit_signal("game_over_triggered")

func _update_risk() -> void:
	if lion_distance > 180.0 and debt < 450:
		risk_level = "Baixo"
	elif lion_distance > 90.0 and debt < 1200:
		risk_level = "Médio"
	else:
		risk_level = "Alto"
