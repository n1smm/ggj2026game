extends StaticBody3D

@export var open_angle: float = 90.0
@export var open_speed: float = 5.0
@export var is_open: bool = false
@export var special_door: bool = false

var _current_angle: float = 0.0
var _target_angle: float = 0.0
var _player_in_range: bool = false
var _can_open_special: bool = false

func _ready():
	_current_angle = rotation_degrees.y
	_target_angle = _current_angle
	add_to_group("interactable")
	$Area3D.add_to_group("interactable")
	if GameManager:
		GameManager.doctor_mask_gained.connect(_on_doctor_mask_gained)

func _on_doctor_mask_gained() -> void:
	_can_open_special = true

func _process(delta):
	if abs(_current_angle - _target_angle) > 0.1:
		_current_angle = lerp(_current_angle, _target_angle, open_speed * delta)
		rotation_degrees.y = _current_angle

# func _unhandled_input(event):
# 	if _player_in_range and Input.is_action_just_pressed("interact"):
# 		toggle_door()

func open_door():
	if not special_door or _can_open_special:
		is_open = true
		_target_angle = open_angle

func close_door():
	is_open = false
	_target_angle = 0.0

func toggle_door():
	if is_open:
		close_door()
	else:
		open_door()

# func _on_area_3d_body_entered(body):
# 	if body.is_in_group("player"):
# 		_player_in_range = true
# 		print("Player vicino alla porta")

# func _on_area_3d_body_exited(body):
# 	if body.is_in_group("player"):
# 		_player_in_range = false
# 		print("Player lontano dalla porta")
