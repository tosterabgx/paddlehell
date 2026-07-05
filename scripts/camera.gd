extends Camera2D

var shake_intensity: float = 0.0
var active_shake_time: float = 0.0
var shake_decay: float = 5.0

var sustained_intensity: float = 0.0
var shake_active: bool = false

var shake_time: float = 0.0
var shake_time_speed: float = 20.0
var noise = FastNoiseLite.new()

func _ready() -> void:
	randomize()
	noise.seed = randi()
	noise.frequency = 2.0

func _process(delta: float) -> void:
	if active_shake_time > 0 or sustained_intensity > 0:
		shake_time += delta * shake_time_speed
		active_shake_time -= delta

		var total_intensity = shake_intensity + sustained_intensity

		offset = Vector2(
			noise.get_noise_2d(shake_time, 0) * total_intensity,
			noise.get_noise_2d(0, shake_time) * total_intensity
		)

		shake_intensity = max(shake_intensity - shake_decay * delta, 0)
	else:
		offset = lerp(offset, Vector2.ZERO, 10.5 * delta)

func screen_shake(intensity: float, time: float) -> void:
	shake_intensity = max(shake_intensity, intensity)
	active_shake_time = max(active_shake_time, time)
	shake_time = 0.0

func start_sustained_shake(intensity: float) -> void:
	sustained_intensity = intensity

func stop_sustained_shake() -> void:
	sustained_intensity = 0.0
