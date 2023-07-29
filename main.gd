extends Control

@export var engine_params := EngineParameters.new()
@export var torque_curve := Curve.new()

var engine := CarEngine.new()

@onready var graph := $HBoxContainer/Graph as Graph


func _ready() -> void:
	engine.engine_params = engine_params
	engine.torque_curve = torque_curve
	
	update()
	add_child(engine)
	
	$HBoxContainer/VBoxContainer/Inertia/Label2.text = "%2.3f kgm^2" % engine_params.inertia
	$HBoxContainer/VBoxContainer/Inertia/HSlider.value = engine_params.inertia
	$HBoxContainer/VBoxContainer/EngineBrake/Label2.text = "%2.2f N" % engine_params.engine_brake
	$HBoxContainer/VBoxContainer/EngineBrake/HSlider.value = engine_params.engine_brake
	$HBoxContainer/VBoxContainer/MaxTorque/Label2.text = "%2.2f N" % engine_params.max_torque
	$HBoxContainer/VBoxContainer/MaxRPM/HSlider.value = engine_params.max_rpm
	$HBoxContainer/VBoxContainer/MaxRPM/Label2.text = "%2.0f" % engine_params.max_rpm
	$HBoxContainer/VBoxContainer/CylinderCount/Label2.text = "%d" % engine_params.cylinder_count
	$HBoxContainer/VBoxContainer/CylinderCount/HSlider.value = engine_params.cylinder_count
	$HBoxContainer/VBoxContainer/IdleRPM/Label2.text = "%2.2f" % engine_params.idle_rpm
	$HBoxContainer/VBoxContainer/IdleRPM/HSlider.value = engine_params.idle_rpm

	$EngineAudioGen.engine_params = engine_params
	engine.engine_params.print_info()


func _process(delta: float) -> void:
	$EngineAudioGen.rpm = engine.rpm
	$HBoxContainer/VBoxContainer/RPM/Label.text = "rpm = %2.2f" % engine.rpm


func update():
	engine_params.update_params()
	$EngineAudioGen.engine_params = engine_params
	$HBoxContainer/VBoxContainer/MaxTorque/Label2.text = "%2.2f N" % engine_params.max_torque
	update_graph()


func update_graph():
	for child in graph.get_children():
		child.queue_free()
		
	var throttle := 0.0
	var torques := []
	
	for j in range(6):
		var vec_array :=  []
		for i in range(10):
			throttle = j * 0.2
			var t = engine.get_engine_torque(i*0.1*engine.engine_params.max_rpm, throttle)
			torques.append(t)
			var vec := Vector2(i*0.1, t)
			vec_array.append(vec)
		
		var amount := float(j / 6.0)
		var color: Color = lerp(Color.BLUE, Color.RED, amount) as Color
		graph.draw_engine_torque(vec_array, engine.engine_params.max_torque, color)


func _on_max_rpm_changed(value: float) -> void:
	engine.engine_params.max_rpm = value
	$HBoxContainer/VBoxContainer/MaxRPM/Label2.text = "%2.0f" % value
	update()


func _on_inertia_changed(value: float) -> void:
	engine.engine_params.inertia = value
	$HBoxContainer/VBoxContainer/Inertia/Label2.text = "%2.3f kgm^2" % value
	update()


func _on_engine_brake_changed(value: float) -> void:
	engine.engine_params.engine_brake = value
	$HBoxContainer/VBoxContainer/EngineBrake/Label2.text = "%2.0f N" % value
	update()


func _on_cylinder_count_changed(value: float) -> void:
	engine.engine_params.cylinder_count = int(value)
	$HBoxContainer/VBoxContainer/CylinderCount/Label2.text = "%d" % int(value)
	update()


func _on_idle_rpm_changed(value: float) -> void:
	engine.engine_params.idle_rpm = value
	$HBoxContainer/VBoxContainer/IdleRPM/Label2.text = "%2.2f" % value
	update()
