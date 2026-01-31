extends CharacterBody3D


const NORMAL_SPEED = 5.0
const CROUCH_SPEED = 2.5
const JUMP_VELOCITY = 4.5
const NORMAL_HEIGHT = 2.0
const CROUCH_HEIGHT = 1.0

var is_crouching = false
var speed = CROUCH_SPEED if is_crouching else NORMAL_SPEED

func _ready() -> void:
	$interaction_zone.body_entered.connect(_on_interaction_zone_body_entered)
	$interaction_zone.body_exited.connect(_on_interaction_zone_body_exited)
	$interaction_zone.area_entered.connect(_on_interaction_zone_area_entered)
	$interaction_zone.area_exited.connect(_on_interaction_zone_area_entered)


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	#handle crouch
	if Input.is_action_pressed("crouch"):
		is_crouching = true
		speed = CROUCH_SPEED
		$CollisionShape3D.shape.height = CROUCH_HEIGHT
	else:
		is_crouching = false
		speed = NORMAL_SPEED
		$CollisionShape3D.shape.height = NORMAL_HEIGHT



	# Get the input direction and handle the movement/deceleration.
	var input_dir := Input.get_vector("move_left", "move_right", "move_back", "move_forward")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

	if direction:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)

	move_and_slide()

	#make the interaction zone stay infront of player
	var offset = 1.0 #offset of interaction zone to player
	var forward = -transform.basis.z.normalized()
	$interaction_zone.global_transform.origin = (
	global_transform.origin + forward * offset)



# signal handlers
func _on_interaction_zone_body_entered(body):
	if body.is_in_group("interactable"):
		print("interactable object in range")

func _on_interaction_zone_body_exited(body):
	if body.is_in_group("interactable"):
		print("interactable object exited range")

func _on_interaction_zone_area_entered(area):
	if area.is_in_group("danger_zone"):
		print("Danger entered!")
	print("area entered")

func _on_interaction_zone_area_exited(area):
	if area.is_in_group("danger_zone"):
		print("Escaped danger")
	print("area exited")
