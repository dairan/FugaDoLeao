extends CanvasLayer

const DANGER_THRESHOLD: float = 100.0  # lion_distance abaixo disso ativa vinheta
const COMBO_COLOR_ACTIVE: Color = Color(1.0, 0.85, 0.1)  # dourado
const COMBO_COLOR_DEFAULT: Color = Color(1, 1, 1)
const RISK_COLOR_LOW: Color = Color(0.3, 0.9, 0.3)
const RISK_COLOR_MED: Color = Color(1.0, 0.8, 0.2)
const RISK_COLOR_HIGH: Color = Color(1.0, 0.25, 0.25)
const COMBO_FONT_SIZE_DEFAULT: int = 16
const COMBO_FONT_SIZE_ACTIVE: int = 22

@onready var score_label: Label = $MarginContainer/VBoxContainer/ScoreLabel
@onready var debt_label: Label = $MarginContainer/VBoxContainer/DebtLabel
@onready var distance_label: Label = $MarginContainer/VBoxContainer/DistanceLabel
@onready var risk_label: Label = $MarginContainer/VBoxContainer/RiskLabel
@onready var combo_label: Label = $MarginContainer/VBoxContainer/ComboLabel
@onready var pause_label: Label = $PauseLabel
@onready var game_over_backdrop: ColorRect = $GameOverBackdrop
@onready var game_over_label: Label = $GameOverLabel
@onready var danger_vignette: ColorRect = $DangerVignette
@onready var flash_overlay: ColorRect = $FlashOverlay

var _flash_tween: Tween

@onready var pause_button: Button = $MarginContainer/TopRightControls/PauseButton

func _ready() -> void:
	GameState.good_item_collected.connect(_on_good_collected)
	GameState.bad_item_collected.connect(_on_bad_collected)
	pause_button.pressed.connect(_on_pause_pressed)

func _on_pause_pressed() -> void:
	GameState.is_paused = !GameState.is_paused

func _process(_delta: float) -> void:
	score_label.text = "Pontuação: %d" % GameState.score
	debt_label.text = "Dívida: R$ %d" % GameState.debt
	distance_label.text = "Distância do leão: %.0f m" % GameState.lion_distance
	risk_label.text = "Risco fiscal: %s" % GameState.risk_level

	combo_label.text = "Combo de pagamento: x%.1f" % GameState.combo_multiplier
	if GameState.combo_count > 0:
		combo_label.text += " (%d)" % GameState.combo_count

	_update_combo_color()
	_update_risk_color()
	_update_danger_vignette()

	pause_label.visible = GameState.is_paused and not GameState.is_game_over
	game_over_backdrop.visible = GameState.is_game_over
	game_over_label.visible = GameState.is_game_over
	if GameState.is_game_over:
		game_over_label.text = "GAME OVER\nO leão te alcançou.\nPontuação final: %d\nAperte R para reiniciar." % GameState.score

func _update_combo_color() -> void:
	var active := GameState.combo_count > 0
	combo_label.add_theme_color_override("font_color", COMBO_COLOR_ACTIVE if active else COMBO_COLOR_DEFAULT)
	combo_label.add_theme_font_size_override("font_size", COMBO_FONT_SIZE_ACTIVE if active else COMBO_FONT_SIZE_DEFAULT)

func _update_risk_color() -> void:
	var color: Color
	match GameState.risk_level:
		"Baixo": color = RISK_COLOR_LOW
		"Médio": color = RISK_COLOR_MED
		_: color = RISK_COLOR_HIGH
	risk_label.add_theme_color_override("font_color", color)

func _update_danger_vignette() -> void:
	var danger_ratio := clampf(1.0 - GameState.lion_distance / DANGER_THRESHOLD, 0.0, 1.0)
	if danger_ratio > 0.6:
		var pulse := (sin(Time.get_ticks_msec() * 0.006) + 1.0) * 0.5
		danger_vignette.modulate.a = lerpf(0.3, 0.7, pulse) * danger_ratio
	else:
		danger_vignette.modulate.a = danger_ratio * 0.45

func _on_good_collected() -> void:
	_flash(Color(0.2, 0.9, 0.3, 0.2))

func _on_bad_collected() -> void:
	_flash(Color(0.9, 0.1, 0.1, 0.25))

func _flash(color: Color) -> void:
	flash_overlay.color = color
	flash_overlay.modulate.a = 1.0
	if _flash_tween:
		_flash_tween.kill()
	_flash_tween = create_tween()
	_flash_tween.tween_property(flash_overlay, "modulate:a", 0.0, 0.3)
