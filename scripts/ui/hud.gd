extends CanvasLayer

@onready var score_label: Label = $MarginContainer/VBoxContainer/ScoreLabel
@onready var speed_label: Label = $MarginContainer/VBoxContainer/SpeedLabel
@onready var debt_label: Label = $MarginContainer/VBoxContainer/DebtLabel
@onready var distance_label: Label = $MarginContainer/VBoxContainer/DistanceLabel
@onready var risk_label: Label = $MarginContainer/VBoxContainer/RiskLabel
@onready var combo_label: Label = $MarginContainer/VBoxContainer/ComboLabel
@onready var pause_label: Label = $PauseLabel
@onready var game_over_label: Label = $GameOverLabel

func _process(_delta: float) -> void:
	score_label.text = "Pontuação: %d" % GameState.score
	speed_label.text = "Velocidade: %.0f" % GameState.speed
	debt_label.text = "Dívida: R$ %d" % GameState.debt
	distance_label.text = "Distância do leão: %.0f m" % GameState.lion_distance
	risk_label.text = "Risco fiscal: %s" % GameState.risk_level
	combo_label.text = "Combo de pagamento: x%.1f" % GameState.combo_multiplier
	if GameState.combo_count > 0:
		combo_label.text += " (%d)" % GameState.combo_count

	pause_label.visible = GameState.is_paused and not GameState.is_game_over
	game_over_label.visible = GameState.is_game_over
	if GameState.is_game_over:
		game_over_label.text = "GAME OVER\nO leão te alcançou.\nAperte R para reiniciar."
