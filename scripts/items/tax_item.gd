extends Area2D

enum ItemKind { GOOD, BAD }

@export var item_kind: ItemKind = ItemKind.GOOD

@onready var visual: Sprite2D = $Visual
@onready var item_label: Label = $Label

var is_active: bool = false
var speed_multiplier: float = 1.0

func setup(p_label: String, p_texture: Texture2D, p_kind: ItemKind) -> void:
	item_kind = p_kind
	item_label.text = p_label
	visual.texture = p_texture

func _physics_process(delta: float) -> void:
	if not is_active or GameState.is_game_over or GameState.is_paused:
		return

	position.x -= GameState.speed * speed_multiplier * delta
	if position.x < -180:
		deactivate()

func _on_body_entered(body: Node) -> void:
	if not is_active or GameState.is_game_over or GameState.is_paused:
		return

	if not body.is_in_group("player"):
		return

	is_active = false
	_apply_collection_effect()
	call_deferred("deactivate")

func reset_state(start_pos: Vector2) -> void:
	position = start_pos
	show()
	set_physics_process(true)
	monitoring = true
	is_active = true

# Pooled items must be hidden and have monitoring disabled when inactive.
func deactivate() -> void:
	hide()
	set_physics_process(false)
	monitoring = false
	is_active = false
	position.x = -9999

func _apply_collection_effect() -> void:
	match item_kind:
		ItemKind.GOOD:
			GameState.apply_good_tax_pickup()
		ItemKind.BAD:
			GameState.apply_bad_tax_event()
