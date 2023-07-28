class_name EngineParameters
extends Resource

@export var cylinder_count := 4
@export var bore := 85.0 # mm
@export var stroke_ratio := 0.95 # mm
@export var max_bmep := 10.5 # Bar
@export var max_rpm := 7000.0
@export var engine_brake := 30.0
@export var inertia := 0.2

var stroke_length := 100.0 # mm
var max_torque := 200.0 # Nm
var displacement := 2.0 # Liters


func _init() -> void:
	update_params()


func update_params():
	stroke_length = bore / stroke_ratio
	displacement = get_displacement()
	max_torque = get_torque_w_bmep(max_bmep)


func get_displacement() -> float:
	return PI * pow(0.5 * bore, 2) * stroke_length * cylinder_count * 0.000001


#func get_brake_power(t, _rpm) -> float:
#	return 2 * PI * t * _rpm / 60000


func get_torque_w_bmep(_bmep: float) -> float:
	return (_bmep * displacement * 100) / (4 * PI)


#func get_bmep(bp, _rpm) -> float:
#	var _bmep := 0.0
#	var area := PI * pow(bore * 0.001 * 0.5, 2)
#	_bmep = (bp * 60) / (stroke_length * 0.001 * area * (_rpm / 2) * cylinder_count * 100)
#	return _bmep


func print_info():
	print("\nEngine info")
	print("Displacement %2.2f l" % displacement)
	print("Max Torque: %2.2f N" % max_torque)
