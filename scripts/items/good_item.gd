extends Area2D

@onready var item_label: Label = $Label

var is_active: bool = false
var speed_multiplier: float = 1.0

func _physics_process(delta: float) -> void:
	if not is_active or GameState.is_game_over or GameState.is_paused:
		return

	position.x -= GameState.speed * speed_multiplier * delta
	if position.x < -180:
		deactivate()

func _on_body_entered(body: Node) -> void:
	if not is_active or GameState.is_game_over or GameState.is_paused:
		return

	if body.is_in_group("player"):
		GameState.apply_good_tax_pickup()
		deactivate()

func set_item_label_text(value: String) -> void:
	if item_label != null:
		item_label.text = value

func reset_state(start_pos: Vector2) -> void:
	position = start_pos
	show()
	set_physics_process(true)
	monitoring = true
	is_active = true

func deactivate() -> void:
	hide()
	set_physics_process(false)
	monitoring = false
	is_active = false
	position.x = -9999

