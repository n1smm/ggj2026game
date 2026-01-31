extends CharacterBody3D


enum States {
	Walking,
	Pursuit
}

@export var walkSpeed : float = 1.0
@export var runSpeed : float = 5.0
@export var patrol_points: Array[Marker3D] = []

@onready var follow_target_3d: FollowTarget3D = $FollowTarget3D
@onready var random_target_3d: RandomTarget3D = $RandomTarget3D

var state : States = States.Walking
var target : Node3D
var current_patrol_index = 0

func _ready() -> void:
	ChangeState(States.Walking)
	$SimpleVision3D.GetSight.connect(_on_simple_vision_3d_get_sight)
	$SimpleVision3D.LostSight.connect(_on_simple_vision_3d_lost_sight)
	$FollowTarget3D.navigation_finished.connect(_on_follow_target_3d_navigation_finished)


func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

func ChangeState(newState : States) -> void:
	state = newState
	match state:
		States.Walking:
			follow_target_3d.ClearTarget()
			follow_target_3d.Speed = walkSpeed
			if patrol_points.size() > 0:
				follow_target_3d.SetFixedTarget(
					patrol_points[current_patrol_index].global_position)
			else:
				follow_target_3d.SetFixedTarget(random_target_3d.GetNextPoint())
			target = null
		States.Pursuit:
			follow_target_3d.Speed = runSpeed
			follow_target_3d.SetTarget(target)

func _on_follow_target_3d_navigation_finished() -> void:
	if patrol_points.size() > 0:
		current_patrol_index = (current_patrol_index + 1) % patrol_points.size()
		follow_target_3d.SetFixedTarget(patrol_points[current_patrol_index].global_position)
	else:
		follow_target_3d.SetFixedTarget(random_target_3d.GetNextPoint())
	# follow_target_3d.SetFixedTarget(random_target_3d.GetNextPoint())

func _on_simple_vision_3d_get_sight(body: Node3D) -> void:
	target = body
	ChangeState(States.Pursuit)

func _on_simple_vision_3d_lost_sight() -> void:
	ChangeState(States.Walking)
