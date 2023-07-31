extends Node

var engine_params := EngineParameters.new()

var playback: AudioStreamGeneratorPlayback
var phase := 0.0

var rpm := 750.0


@onready var sample_hz = $AudioStreamPlayer.stream.mix_rate

func _ready():
	$AudioStreamPlayer.play()
	playback = $AudioStreamPlayer.get_stream_playback()
	fill_buffer(rpm / 120)
	
	engine_params.update_params()


func _process(delta: float) -> void:
	var engine_phase = rpm / 120
	var cylinder_phase = engine_params.cylinder_count * engine_phase
	
	fill_buffer(cylinder_phase)


func fill_buffer(pulse_freq: float):
	var increment = pulse_freq / sample_hz
	var frames_available = playback.get_frames_available()
	
	var exhaust := 0.0
	var intake := 0.0
	var piston := 0.0
	var ignition := 0.0

	for i in range(frames_available):
		exhaust = exhaust_valve(phase)
		intake = intake_valve(phase)
		piston = piston_motion(phase)
		ignition = ignition_fire(phase, 0.1)
		
		var frame := exhaust + intake + piston + ignition
		
		playback.push_frame(Vector2.ONE * frame)
		phase = fmod(phase + increment, 1.0)


func exhaust_valve(x: float) -> float:
	return -sin(4.0 * PI * x) if x > 0.75 and x < 1.0 else 0.0


func intake_valve(x: float) -> float:
	return sin(4.0 * PI * x) if x > 0.0 and x < 0.25 else 0.0


func piston_motion(x: float) -> float:
	return cos(4.0 * PI * x)


func ignition_fire(x: float, t: float) -> float:
	return sin(2.0 * PI * (x * t + 0.5)) if x > 0.0 and x < t else 0.0
