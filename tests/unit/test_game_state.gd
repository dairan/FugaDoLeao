extends GutTest

func before_each() -> void:
	GameState.reset()

# --- reset ---

func test_reset_clears_score() -> void:
	GameState.score = 100
	GameState.reset()
	assert_eq(GameState.score, 0)

func test_reset_restores_lion_distance() -> void:
	GameState.lion_distance = 0.0
	GameState.reset()
	assert_eq(GameState.lion_distance, GameState.START_DISTANCE)

func test_reset_clears_debt() -> void:
	GameState.debt = 500
	GameState.reset()
	assert_eq(GameState.debt, 0)

func test_reset_clears_combo() -> void:
	GameState.combo_count = 5
	GameState.combo_multiplier = 2.5
	GameState.reset()
	assert_eq(GameState.combo_count, 0)
	assert_eq(GameState.combo_multiplier, 1.0)

func test_reset_clears_game_over_flag() -> void:
	GameState.is_game_over = true
	GameState.reset()
	assert_false(GameState.is_game_over)

# --- good pickup ---

func test_good_pickup_first_gives_10_points() -> void:
	GameState.apply_good_tax_pickup()
	assert_eq(GameState.score, 10)

func test_good_pickup_increases_lion_distance() -> void:
	var before := GameState.lion_distance
	GameState.apply_good_tax_pickup()
	assert_gt(GameState.lion_distance, before)

func test_good_pickup_reduces_positive_debt() -> void:
	GameState.debt = 200
	GameState.apply_good_tax_pickup()
	assert_lt(GameState.debt, 200)

func test_good_pickup_debt_floor_is_zero() -> void:
	GameState.debt = 0
	GameState.apply_good_tax_pickup()
	assert_eq(GameState.debt, 0)

func test_good_pickup_increments_combo() -> void:
	GameState.apply_good_tax_pickup()
	assert_eq(GameState.combo_count, 1)

func test_good_pickup_resets_combo_timer() -> void:
	GameState.apply_good_tax_pickup()
	assert_eq(GameState.combo_timer, GameState.COMBO_WINDOW_SECONDS)

func test_good_pickup_multiplier_grows_with_combo() -> void:
	GameState.apply_good_tax_pickup()
	GameState.apply_good_tax_pickup()
	assert_gt(GameState.combo_multiplier, 1.0)

func test_good_pickup_multiplier_caps_at_3() -> void:
	for i in range(20):
		GameState.apply_good_tax_pickup()
	assert_lte(GameState.combo_multiplier, 3.0)

func test_good_pickup_emits_signal() -> void:
	watch_signals(GameState)
	GameState.apply_good_tax_pickup()
	assert_signal_emitted(GameState, "good_item_collected")

func test_good_pickup_ignored_after_game_over() -> void:
	GameState.is_game_over = true
	GameState.apply_good_tax_pickup()
	assert_eq(GameState.score, 0)

# --- bad event ---

func test_bad_event_reduces_score() -> void:
	GameState.score = 20
	GameState.apply_bad_tax_event()
	assert_eq(GameState.score, 12)

func test_bad_event_score_floor_is_zero() -> void:
	GameState.score = 0
	GameState.apply_bad_tax_event()
	assert_eq(GameState.score, 0)

func test_bad_event_reduces_lion_distance() -> void:
	var before := GameState.lion_distance
	GameState.apply_bad_tax_event()
	assert_lt(GameState.lion_distance, before)

func test_bad_event_increases_debt_by_100() -> void:
	GameState.debt = 0
	GameState.apply_bad_tax_event()
	assert_eq(GameState.debt, 100)

func test_bad_event_breaks_combo_count() -> void:
	GameState.apply_good_tax_pickup()
	GameState.apply_good_tax_pickup()
	GameState.apply_bad_tax_event()
	assert_eq(GameState.combo_count, 0)

func test_bad_event_resets_multiplier_to_1() -> void:
	GameState.apply_good_tax_pickup()
	GameState.apply_good_tax_pickup()
	GameState.apply_bad_tax_event()
	assert_eq(GameState.combo_multiplier, 1.0)

func test_bad_event_resets_combo_timer() -> void:
	GameState.apply_good_tax_pickup()
	GameState.apply_bad_tax_event()
	assert_eq(GameState.combo_timer, 0.0)

func test_bad_event_emits_signal() -> void:
	watch_signals(GameState)
	GameState.apply_bad_tax_event()
	assert_signal_emitted(GameState, "bad_item_collected")

func test_bad_event_triggers_game_over_when_distance_depleted() -> void:
	watch_signals(GameState)
	GameState.lion_distance = GameState.BAD_DISTANCE_PENALTY - 1.0
	GameState.apply_bad_tax_event()
	assert_signal_emitted(GameState, "game_over_triggered")
	assert_true(GameState.is_game_over)

# --- passive drain ---

func test_passive_drain_reduces_lion_distance() -> void:
	var before := GameState.lion_distance
	GameState.tick_passive_chase(1.0)
	assert_lt(GameState.lion_distance, before)

func test_passive_drain_triggers_game_over_at_zero() -> void:
	watch_signals(GameState)
	GameState.lion_distance = 0.1
	GameState.tick_passive_chase(1.0)
	assert_signal_emitted(GameState, "game_over_triggered")
	assert_true(GameState.is_game_over)

func test_passive_drain_skipped_when_paused() -> void:
	GameState.is_paused = true
	var before := GameState.lion_distance
	GameState.tick_passive_chase(1.0)
	assert_eq(GameState.lion_distance, before)

func test_combo_timer_expires_and_resets_combo() -> void:
	GameState.apply_good_tax_pickup()
	assert_eq(GameState.combo_count, 1)
	GameState.tick_passive_chase(GameState.COMBO_WINDOW_SECONDS + 0.1)
	assert_eq(GameState.combo_count, 0)
	assert_eq(GameState.combo_multiplier, 1.0)

# --- risk level ---

func test_risk_low_when_distance_high_and_debt_low() -> void:
	GameState.lion_distance = 200.0
	GameState.debt = 0
	GameState._update_risk()
	assert_eq(GameState.risk_level, "Baixo")

func test_risk_medium_when_distance_medium_and_debt_moderate() -> void:
	GameState.lion_distance = 100.0
	GameState.debt = 0
	GameState._update_risk()
	assert_eq(GameState.risk_level, "Médio")

func test_risk_high_when_distance_low() -> void:
	GameState.lion_distance = 50.0
	GameState.debt = 9999
	GameState._update_risk()
	assert_eq(GameState.risk_level, "Alto")
