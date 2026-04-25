extends GutTest

const GOOD_SCENE := preload("res://scenes/items/GoodItem.tscn")
const BAD_SCENE := preload("res://scenes/items/BadItem.tscn")

func before_each() -> void:
	GameState.reset()

# --- reset_state ---

func test_reset_state_activates_item() -> void:
	var item: Node2D = GOOD_SCENE.instantiate()
	add_child_autofree(item)
	item.deactivate()
	item.reset_state(Vector2(100.0, 100.0))
	assert_true(item.is_active)

func test_reset_state_makes_item_visible() -> void:
	var item: Node2D = GOOD_SCENE.instantiate()
	add_child_autofree(item)
	item.deactivate()
	item.reset_state(Vector2(100.0, 100.0))
	assert_true(item.visible)

func test_reset_state_enables_monitoring() -> void:
	var item: Node2D = GOOD_SCENE.instantiate()
	add_child_autofree(item)
	item.deactivate()
	item.reset_state(Vector2(100.0, 100.0))
	assert_true(item.monitoring)

func test_reset_state_places_item_at_given_position() -> void:
	var item: Node2D = GOOD_SCENE.instantiate()
	add_child_autofree(item)
	item.reset_state(Vector2(500.0, 300.0))
	assert_eq(item.position, Vector2(500.0, 300.0))

# --- deactivate ---

func test_deactivate_sets_is_active_false() -> void:
	var item: Node2D = GOOD_SCENE.instantiate()
	add_child_autofree(item)
	item.reset_state(Vector2(100.0, 100.0))
	item.deactivate()
	assert_false(item.is_active)

func test_deactivate_hides_item() -> void:
	var item: Node2D = GOOD_SCENE.instantiate()
	add_child_autofree(item)
	item.reset_state(Vector2(100.0, 100.0))
	item.deactivate()
	assert_false(item.visible)

func test_deactivate_disables_monitoring() -> void:
	var item: Node2D = GOOD_SCENE.instantiate()
	add_child_autofree(item)
	item.reset_state(Vector2(100.0, 100.0))
	item.deactivate()
	await get_tree().process_frame
	assert_false(item.monitoring)

# --- collision ---

func test_collision_with_non_player_body_has_no_effect_on_score() -> void:
	var item: Node2D = GOOD_SCENE.instantiate()
	add_child_autofree(item)
	item.reset_state(Vector2(100.0, 100.0))
	var before_score := GameState.score
	var dummy := Node2D.new()
	add_child_autofree(dummy)
	item._on_body_entered(dummy)
	assert_eq(GameState.score, before_score)

func test_collision_with_non_player_body_keeps_item_active() -> void:
	var item: Node2D = GOOD_SCENE.instantiate()
	add_child_autofree(item)
	item.reset_state(Vector2(100.0, 100.0))
	var dummy := Node2D.new()
	add_child_autofree(dummy)
	item._on_body_entered(dummy)
	assert_true(item.is_active)

func test_good_item_collision_with_player_emits_signal() -> void:
	var item: Node2D = GOOD_SCENE.instantiate()
	add_child_autofree(item)
	item.reset_state(Vector2(100.0, 100.0))
	var player := Node2D.new()
	player.add_to_group("player")
	add_child_autofree(player)
	watch_signals(GameState)
	item._on_body_entered(player)
	assert_signal_emitted(GameState, "good_item_collected")

func test_good_item_collision_with_player_deactivates_item() -> void:
	var item: Node2D = GOOD_SCENE.instantiate()
	add_child_autofree(item)
	item.reset_state(Vector2(100.0, 100.0))
	var player := Node2D.new()
	player.add_to_group("player")
	add_child_autofree(player)
	item._on_body_entered(player)
	assert_false(item.is_active)

func test_bad_item_collision_with_player_emits_signal() -> void:
	var item: Node2D = BAD_SCENE.instantiate()
	add_child_autofree(item)
	item.reset_state(Vector2(100.0, 100.0))
	var player := Node2D.new()
	player.add_to_group("player")
	add_child_autofree(player)
	watch_signals(GameState)
	item._on_body_entered(player)
	assert_signal_emitted(GameState, "bad_item_collected")

func test_bad_item_collision_with_player_deactivates_item() -> void:
	var item: Node2D = BAD_SCENE.instantiate()
	add_child_autofree(item)
	item.reset_state(Vector2(100.0, 100.0))
	var player := Node2D.new()
	player.add_to_group("player")
	add_child_autofree(player)
	item._on_body_entered(player)
	assert_false(item.is_active)

func test_collision_ignored_when_item_inactive() -> void:
	var item: Node2D = GOOD_SCENE.instantiate()
	add_child_autofree(item)
	item.deactivate()
	var before_score := GameState.score
	var player := Node2D.new()
	player.add_to_group("player")
	add_child_autofree(player)
	item._on_body_entered(player)
	assert_eq(GameState.score, before_score)
