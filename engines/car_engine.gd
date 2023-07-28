class_name CarEngine
extends Node

const AV_2_RPM: float = 60 / TAU

@export var engine_params := EngineParameters.new()
@export var torque_curve := Curve.new()

var throttle := 0.0
var torque := 50.0
var rpm := 900.0

var reaction_torque := 0.0


func _ready() -> void:
	engine_params.update_params()


func _process(delta: float) -> void:
	throttle = Input.get_action_strength("throttle")
#	print(throttle)
	var engine_brake_torque := rpm / engine_params.max_rpm * engine_params.engine_brake
	torque = get_engine_torque(rpm, throttle) + reaction_torque - engine_brake_torque
	rpm += AV_2_RPM * delta * torque / engine_params.inertia
	rpm = clampf(rpm, 0, 20000)
	
	if rpm > engine_params.max_rpm:
		torque = 0.0
		rpm -= 500
	
#	print(torque)
#	print(rpm)


func get_engine_torque(p_rpm: float, throttle_input: float) -> float:
	var rpm_mult := p_rpm / engine_params.max_rpm
	return torque_curve.sample_baked(rpm_mult) * engine_params.max_torque * throttle_input


