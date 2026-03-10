extends Area2D

@onready var item_label: Label = $Label

func _physics_process(delta: float) -> void:
    if GameState.is_game_over or GameState.is_paused:
        return

    position.x -= GameState.speed * delta
    if position.x < -180:
        queue_free()

func _on_body_entered(body: Node) -> void:
    if GameState.is_game_over or GameState.is_paused:
        return

    if body.is_in_group("player"):
        GameState.apply_bad_tax_event()
        queue_free()

func set_item_label_text(value: String) -> void:
    item_label.text = value
