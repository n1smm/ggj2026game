extends Node

signal aggression_changed(factor: float)

@export var game_duration: float = 5.0  # 5 minutes default

var time_left: float = 0.0
var aggression_factor: float = 0.001  # Start at 0.0 (no aggression), goes to 1.0 (max)

func _ready() -> void:
	time_left = game_duration

func _process(delta: float) -> void:
	if time_left > 0:
		time_left -= delta
		# As time decreases, aggression increases
		# When time_left = game_duration -> factor = 0.0 (no boost)
		# When time_left = 0 -> factor = 1.0 (max boost)
		aggression_factor = 1.0 - (time_left / game_duration)  # 0.0 -> 1.0
		aggression_changed.emit(aggression_factor)
	else:
		time_left = game_duration
		aggression_factor = 0.001

func get_aggression_factor() -> float:
	return aggression_factor

func get_time_left() -> float:
	return time_left
