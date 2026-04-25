extends MarginContainer

## Script para ajustar automaticamente as margens do HUD para a Safe Area do dispositivo (Notch/Dynamic Island).

func _ready() -> void:
	update_safe_area()
	get_viewport().size_changed.connect(update_safe_area)

func update_safe_area() -> void:
	# No Godot, get_display_safe_area() retorna a area segura em coordenadas da tela.
	# Precisamos converter para margens relativas ao nosso container.
	var safe_area := DisplayServer.get_display_safe_area()
	var window_size := DisplayServer.window_get_size()
	
	if window_size.x == 0 or window_size.y == 0:
		return

	# Define as margens com base na diferença entre o tamanho da janela e a safe area.
	add_theme_constant_override("margin_left", safe_area.position.x)
	add_theme_constant_override("margin_top", safe_area.position.y)
	add_theme_constant_override("margin_right", window_size.x - safe_area.end.x)
	add_theme_constant_override("margin_bottom", window_size.y - safe_area.end.y)
