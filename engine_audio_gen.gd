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
	var firing_hz = engine_params.cylinder_count * rpm / 120
	var engine_phase = rpm / 120
	
#	print_debug(firing_hz)
#	print_debug(engine_phase)
	
	fill_buffer(firing_hz)


func fill_buffer(pulse_freq: float):
	var increment = pulse_freq / sample_hz
	var frames_available = playback.get_frames_available()

	for i in range(frames_available):
		var frame := sin(phase * TAU) * sin(phase * 1.5 * TAU)
		playback.push_frame(Vector2.ONE * frame)
		phase = fmod(phase + increment, 1.0)

	
