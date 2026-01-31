extends CharacterBody3D


const NORMAL_SPEED = 5.0
const CROUCH_SPEED = 2.5
const JUMP_VELOCITY = 4.5
const CROUCH_HEIGHT = 0.5

var is_crouching = false
var speed = CROUCH_SPEED if is_crouching else NORMAL_SPEED
var normal_height = 0.0
var mouse_sensitivity = 0.003
var mouse_delta = Vector2.ZERO

func _ready() -> void:
	normal_height = $CollisionShape3D.shape.height

	$interaction_zone.body_entered.connect(_on_interaction_zone_body_entered)
	$interaction_zone.body_exited.connect(_on_interaction_zone_body_exited)
	$interaction_zone.area_entered.connect(_on_interaction_zone_area_entered)
	$interaction_zone.area_exited.connect(_on_interaction_zone_area_entered)
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

	add_to_group("player")

func _physics_process(delta: float) -> void:
	# Check mouse mode every frame
	if Input.get_mouse_mode() != Input.MOUSE_MODE_CAPTURED:
		print("WARNING: Mouse mode changed to: ", Input.get_mouse_mode())
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	# Add the gravity
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Handle crouch
	if Input.is_action_pressed("crouch"):
		is_crouching = true
		speed = CROUCH_SPEED
		$CollisionShape3D.shape.height = normal_height * CROUCH_HEIGHT
	else:
		is_crouching = false
		speed = NORMAL_SPEED
		$CollisionShape3D.shape.height = normal_height

	# Manual input direction (not using Input.get_vector)
	var input_dir = Vector2.ZERO
	if Input.is_action_pressed("move_right"):
		input_dir.x += 1.0
	if Input.is_action_pressed("move_left"):
		input_dir.x -= 1.0
	if Input.is_action_pressed("move_back"):
		input_dir.y += 1.0
	if Input.is_action_pressed("move_forward"):
		input_dir.y -= 1.0

	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

	if direction:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)

	move_and_slide()

	# Interaction zone positioning
	var offset = 1.0
	var forward = -transform.basis.z.normalized()
	$interaction_zone.global_transform.origin = global_transform.origin + forward * offset

#func _physics_process(delta: float) -> void:
#	# Add the gravity.
#	if not is_on_floor():
#		velocity += get_gravity() * delta

#	#mouse movement
#	# rotation.y -= mouse_delta.x * mouse_sensitivity
#	# mouse_delta = Vector2.ZERO

#	# Handle jump.
#	if Input.is_action_just_pressed("jump") and is_on_floor():
#		velocity.y = JUMP_VELOCITY

#	#handle crouch
#	if Input.is_action_pressed("crouch"):
#		is_crouching = true
#		speed = CROUCH_SPEED
#		$CollisionShape3D.shape.height = normal_height * CROUCH_HEIGHT
#	else:
#		is_crouching = false
#		speed = NORMAL_SPEED
#		$CollisionShape3D.shape.height = normal_height



#	# Get the input direction and handle the movement/deceleration.
#	var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_back")
#	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
#	if input_dir != Vector2.ZERO:
#			print("MOVING: ", input_dir)  # ADD THIS

#	if direction:
#		velocity.x = direction.x * speed
#		velocity.z = direction.z * speed
#	else:
#		velocity.x = move_toward(velocity.x, 0, speed)
#		velocity.z = move_toward(velocity.z, 0, speed)


#	move_and_slide()

#	#make the interaction zone stay infront of player
#	var offset = 1.0 #offset of interaction zone to player
#	var forward = -transform.basis.z.normalized()
#	$interaction_zone.global_transform.origin = (
#	global_transform.origin + forward * offset)


# func _input(event: InputEvent) -> void:
# 	if event is InputEventMouseMotion:
# 		mouse_delta += event.relative

func _input(event):
	print("_input called with: ", event.get_class())
	if event is InputEventMouseMotion:
		print("MOUSE MOTION - captured mode: ", Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED)
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			print("ROTATING by: ", event.relative)
			rotate_y(-event.relative.x * mouse_sensitivity)



# signal handlers
func _on_interaction_zone_body_entered(body: Node3D) -> void:
	if body.is_in_group("interactable"):
		print("interactable object in range")

func _on_interaction_zone_body_exited(body: Node3D) -> void:
	if body.is_in_group("interactable"):
		print("interactable object exited range")

func _on_interaction_zone_area_entered(area: Area3D) -> void:
	if area.is_in_group("danger_zone"):
		print("Danger entered!")
	print("area entered")

func _on_interaction_zone_area_exited(area: Area3D) -> void:
	if area.is_in_group("danger_zone"):
		print("Escaped danger")
	print("area exited")
