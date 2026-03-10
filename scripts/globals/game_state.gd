extends Node

const BASE_SPEED: float = 320.0
const MIN_SPEED: float = 170.0
const MAX_SPEED: float = 620.0
const START_DISTANCE: float = 220.0
const MAX_DISTANCE: float = 9999.0
const COMBO_WINDOW_SECONDS: float = 2.2

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

func apply_good_tax_pickup() -> void:
    if is_game_over:
        return

    combo_count += 1
    combo_timer = COMBO_WINDOW_SECONDS
    combo_multiplier = min(3.0, 1.0 + combo_count * 0.15)

    var score_gain := int(round(10.0 * combo_multiplier))
    score += score_gain
    speed = clamp(speed + 22.0 + combo_count * 1.5, MIN_SPEED, MAX_SPEED)
    lion_distance = clamp(lion_distance + 22.0 + combo_count * 1.2, 0.0, MAX_DISTANCE)
    debt = max(0, debt - 55 - combo_count * 2)
    _update_risk()

func apply_bad_tax_event() -> void:
    if is_game_over:
        return

    score = max(0, score - 8)
    speed = clamp(speed - 38.0, MIN_SPEED, MAX_SPEED)
    lion_distance = clamp(lion_distance - 32.0, 0.0, MAX_DISTANCE)
    debt += 100
    combo_count = 0
    combo_multiplier = 1.0
    combo_timer = 0.0
    _update_risk()
    if lion_distance <= 0.0:
        is_game_over = true

func tick_passive_chase(delta: float) -> void:
    if is_game_over or is_paused:
        return

    if combo_timer > 0.0:
        combo_timer = max(0.0, combo_timer - delta)
        if combo_timer <= 0.0:
            combo_count = 0
            combo_multiplier = 1.0

    lion_distance = clamp(lion_distance - _compute_chase_speed() * delta, 0.0, MAX_DISTANCE)
    _update_risk()
    if lion_distance <= 0.0:
        is_game_over = true

func _update_risk() -> void:
    if lion_distance > 180.0 and debt < 450:
        risk_level = "Baixo"
    elif lion_distance > 90.0 and debt < 1200:
        risk_level = "Médio"
    else:
        risk_level = "Alto"

func _compute_chase_speed() -> float:
    var speed_relief := (speed - BASE_SPEED) * 0.28
    var debt_pressure := debt * 0.02
    var raw_chase_speed := 120.0 + debt_pressure - speed_relief
    return clamp(raw_chase_speed, 35.0, 280.0)
