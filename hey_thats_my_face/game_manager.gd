extends Node

signal aggression_changed(factor: float)
signal speed_up_mob()
signal mob_killed()
signal doctor_mask_gained()
signal mask_progress_changed(progress: int)
signal scalpel_durability_change(progress: int)

@export var game_duration: float = 20.0
@export var idle = false
@export var aggression_factor_w_doctor_face: float = 0.3

var time_left: float = 0.1
var aggression_factor: float = 0.001  # Start at almost 0.0 (no aggression), goes to 1.0 (max)

func _ready() -> void:
	time_left = game_duration

func _process(delta: float) -> void:
	if not idle:
		if time_left > 0:
			time_left -= delta
			aggression_factor = 1.0 - (time_left / game_duration)
			aggression_changed.emit(aggression_factor)
		else:
			stop_timer()
			# time_left = game_duration
			# aggression_factor = 0.001

func start_timer() -> void:
	time_left = game_duration
	aggression_factor = 0.001
	idle = false
	pass

func stop_timer() -> void:
	time_left = game_duration
	idle = true
	aggression_factor = 1.0
	pass

func stop_timer_doctor() -> void:
	time_left = game_duration
	idle = true
	aggression_factor = aggression_factor_w_doctor_face

func get_aggression_factor() -> float:
	return aggression_factor

func get_time_left() -> float:
	return time_left
