class_name Graph
extends VBoxContainer

#var line_count = 5

func _on_resized() -> void:
	print_debug("Graph resized")


func draw_engine_torque(points: Array, max_torque: float, color: Color):
	var line := Line2D.new()
	line.width = 2
	line.position.y = DisplayServer.window_get_size().y * 0.5
	line.clear_points()
	
	var i := 0
	for point in points:
		point.x = (i+1) * 0.1 * DisplayServer.window_get_size().x * 0.5
		point.y /= max_torque
		point.y *= DisplayServer.window_get_size().y * 0.5
		point.y *= -1
		line.add_point(point)
		i += 1
	
	line.default_color = color
	
	add_child(line)
	
