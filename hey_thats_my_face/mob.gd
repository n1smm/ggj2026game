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
var is_dead = false

# Base values for aggression scaling
var mob_aggression_factor = 0.01
var base_distance: float = 5.0
var base_cone_width: float = 5.0
var base_cone_height: float = 5.0
var base_run_speed: float = 5.0




func _ready() -> void:
	# Store base values from scene settings
	base_distance = $SimpleVision3D.Distance
	base_cone_width = $SimpleVision3D.EndWidth
	base_cone_height = $SimpleVision3D.EndHeight
	base_run_speed = runSpeed

	ChangeState(States.Walking)
	$Sprite3D.double_sided = false
	$Sprite3DBack.double_sided = false
	$SimpleVision3D.GetSight.connect(_on_simple_vision_3d_get_sight)
	$SimpleVision3D.LostSight.connect(_on_simple_vision_3d_lost_sight)
	$FollowTarget3D.navigation_finished.connect(_on_follow_target_3d_navigation_finished)

	$InteractionZone.add_to_group("danger_zone")
	$InteractionZone.body_entered.connect(_on_interaction_zone_body_entered)
	$KillZone.add_to_group("killable")
	
	# Add mob to group so doors can detect it
	add_to_group("mob")
	
	# Connect to GameManager if it exists
	if GameManager:
		GameManager.aggression_changed.connect(_on_aggression_changed)
		GameManager.speed_up_mob.connect(_on_speed_up)
		# Set initial values immediately
		_on_aggression_changed(GameManager.get_aggression_factor())

	
	

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

	var offset = 0.2
	var forward = -transform.basis.z.normalized()
	var back = transform.basis.z.normalized()
	$InteractionZone.global_transform.origin = global_transform.origin + forward * offset
	$KillZone.global_transform.origin = global_transform.origin + back * offset

func ChangeState(newState : States) -> void:
	print("Changing state from ", States.keys()[state], " to ", States.keys()[newState])
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
			print("Setting pursuit target: ", target)
			print("Pursuit speed: ", runSpeed)
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
	print("Vision detected body: ", body.name)
	target = body
	ChangeState(States.Pursuit)

func _on_simple_vision_3d_lost_sight() -> void:
	print("Vision lost sight")
	ChangeState(States.Walking)

func _on_aggression_changed(factor: float) -> void:
	# Update vision parameters based on aggression
	# factor goes from 0.0 (start) to 1.0 (end)
	# Use a minimum of 0.3 so mobs always have some vision
	var adjusted_factor = max(0.3, factor)
	$SimpleVision3D.Distance = base_distance * adjusted_factor
	$SimpleVision3D.EndWidth = base_cone_width * adjusted_factor
	$SimpleVision3D.EndHeight = base_cone_height * adjusted_factor
	# Keep pursuit speed constant at base value
	runSpeed = base_run_speed
	mob_aggression_factor = factor
	
	# CRITICAL: Rebuild the vision shape for changes to take effect
	rebuild_vision_cone()

func _on_speed_up() -> void:
	print("signal on speed change")
	walkSpeed += 0.3	
	runSpeed += 0.1
	match state:
		States.Walking:
			follow_target_3d.Speed = walkSpeed
		States.Pursuit:
			follow_target_3d.Speed = runSpeed


func die() -> void:
	if is_dead:
		return
	is_dead = true
	var dead_mob_scene = preload("res://dead_mob.tscn")
	var dead_mob = dead_mob_scene.instantiate()
	var pos = global_transform.origin
	get_tree().current_scene.add_child(dead_mob)
	dead_mob.global_transform.origin.x = pos.x
	dead_mob.global_transform.origin.z = pos.z
	dead_mob.global_transform.origin.y = 0.1
	queue_free()

func _on_interaction_zone_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		print("GAME OVER - Mob caught player!")
		get_tree().change_scene_to_file("res://Scenes/gameover.tscn")
	

func rebuild_vision_cone() -> void:
	# Rebuild the vision cone shape with updated parameters
	var vision_shape = ConvexPolygonShape3D.new()
	var points = PackedVector3Array()
	var dist = $SimpleVision3D.Distance
	var base_w = $SimpleVision3D.BaseWidth
	var end_w = $SimpleVision3D.EndWidth
	var base_h = $SimpleVision3D.BaseHeight
	var end_h = $SimpleVision3D.EndHeight
	var base_cone = $SimpleVision3D.BaseConeSize
	
	points.append(Vector3(0, 0, 0))
	points.append(Vector3(base_w/2, 0, -base_cone))
	points.append(Vector3(end_w/2, 0, -dist))
	points.append(Vector3(-(base_w/2), 0, -base_cone))
	points.append(Vector3(-(end_w/2), 0, -dist))
	points.append(Vector3(0, base_h, 0))
	points.append(Vector3(base_w/2, base_h, -base_cone))
	points.append(Vector3(end_w/2, end_h, -dist))
	points.append(Vector3(-(base_w/2), base_h, -base_cone))
	points.append(Vector3(-(end_w/2), end_h, -dist))
	
	vision_shape.points = points
	$SimpleVision3D.VisionArea.shape = vision_shape
