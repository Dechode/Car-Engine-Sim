class_name CarEngine
extends Node

const AV_2_RPM: float = 60 / TAU

@export var engine_params := EngineParameters.new()
@export var torque_curve := Curve.new()

var throttle := 0.0
var torque := 50.0
var rpm := 900.0

var reaction_torque := 0.0 # Set by Clutch when it gets implemented

var rng := RandomNumberGenerator.new()


func _ready() -> void:
	engine_params.update_params()
	rng.randomize()


func _process(delta: float) -> void:
	throttle = Input.get_action_strength("throttle")
	
	torque = get_engine_torque(rpm, throttle)
	
	rpm += AV_2_RPM * delta * (torque + reaction_torque) / engine_params.inertia
#	rpm = clampf(rpm + rng.randf() * 5.0, engine_params.idle_rpm, 20000)
	rpm = clampf(rpm, engine_params.idle_rpm, 20000)
	
	if rpm >= engine_params.max_rpm:
		torque = 0.0
		rpm -= 1000.0


func get_engine_torque(p_rpm: float, throttle_input: float) -> float:
	var rpm_mult := p_rpm / engine_params.max_rpm
	var engine_brake_torque := rpm_mult * engine_params.engine_brake
	var t100 = torque_curve.sample_baked(rpm_mult) * engine_params.max_torque
	var t0 := -engine_brake_torque
	return lerpf(t0, t100, throttle_input)


