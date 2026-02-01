extends CharacterBody3D


const NORMAL_SPEED = 5.0
const CROUCH_SPEED = 2.5
const JUMP_VELOCITY = 4.5
const CROUCH_HEIGHT = 0.5
const MAX_MASK_TRANSITIONS = 6

var PICKABLES = {
	"Scalpel": 0,
	"Mask": 0,
	"Doctor": false
	}

@export var scalpel_max_durability = 15
@export var scalpel_hit_loss_durability = 5

@onready var interact_prompt_label: Label = get_node_or_null("../Interface/CanvasLayer/InteractionPrompt")
@onready var time_label: Label = get_node_or_null("../Interface/CanvasLayer/Time")
var is_crouching = false
var speed = CROUCH_SPEED if is_crouching else NORMAL_SPEED
var normal_height = 0.0
var mouse_sensitivity = 0.003
var mouse_delta = Vector2.ZERO

var can_kill := false
var can_interact := false
var can_pickup := false
var kill_target: Node3D = null
var pickup_target = null
var interact_target: StaticBody3D = null

var time_left := 0.0
var aggression := 0.001


func _ready() -> void:
	normal_height = $CollisionShape3D.shape.height

	$interaction_zone.body_entered.connect(_on_interaction_zone_body_entered)
	$interaction_zone.body_exited.connect(_on_interaction_zone_body_exited)
	$interaction_zone.area_entered.connect(_on_interaction_zone_area_entered)
	$interaction_zone.area_exited.connect(_on_interaction_zone_area_exited)
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

	add_to_group("player")
	if GameManager:
		GameManager.aggression_changed.connect(_on_aggression_changed)



func _physics_process(delta: float) -> void:
	time_label.text = str(aggression)

	# Check mouse mode every frame
	if Input.get_mouse_mode() != Input.MOUSE_MODE_CAPTURED:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	# Add the gravity
	if not is_on_floor():
		velocity += get_gravity() * delta

	#handle interact
	if Input.is_action_just_pressed("interact"):
		if can_kill and kill_target and PICKABLES["Scalpel"] > 0:
			var killed_name  = kill_target.name
			if kill_target.has_method("die") and killed_name != "Doctor":
				kill_target.die()
			else:
				kill_target.queue_free()
			if interact_prompt_label:
				interact_prompt_label.text = ""
				interact_prompt_label.visible = false
				PICKABLES["Scalpel"] -= scalpel_hit_loss_durability
				if GameManager:
					GameManager.emit_signal("speed_up_mob")
			if killed_name == "Doctor":
				PICKABLES["Doctor"] = true
				if GameManager:
					GameManager.emit_signal("doctor_mask_gained")
				print("you killed Doctor!")

			can_kill = false
			kill_target = null
		elif can_interact and interact_target:
			interact_target.toggle_door()
			if interact_prompt_label:
				interact_prompt_label.text = ""
				interact_prompt_label.visible = false
		elif can_pickup and pickup_target:
			if interact_prompt_label:
				interact_prompt_label.text = ""
				interact_prompt_label.visible = false

			if pickup_target.has_method("handle_face"):
				PICKABLES["Mask"] = MAX_MASK_TRANSITIONS
				pickup_target.handle_face()
				GameManager.start_timer()
				print("harvested face/mask")
			elif pickup_target.name == "Scalpel":
				PICKABLES["Scalpel"] = scalpel_max_durability
				pickup_target.queue_free()
				print("scalpel")
			elif pickup_target.name == "Doctor":
				PICKABLES["Doctor"] = true
				print("doctor mask")
			else:
				print("unknown pickable: " + pickup_target.name)





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
	var offset = 0.5
	var forward = -transform.basis.z.normalized()
	$interaction_zone.global_transform.origin = global_transform.origin + forward * offset


func _input(event):
	if event is InputEventMouseMotion:
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			rotate_y(-event.relative.x * mouse_sensitivity)



# signal handlers
func _on_interaction_zone_body_entered(body: Node3D) -> void:
	if body.is_in_group("interactable"):
		print("interactable object in range")
	if body.is_in_group("pickable"):
		if interact_prompt_label:
			interact_prompt_label.text = "Pick up {press E}"
			interact_prompt_label.visible = true
		can_pickup = true
		pickup_target = body
	if body.is_in_group("defaceable"):
		if interact_prompt_label:
			interact_prompt_label.text = "cut the face off {press E}"
			interact_prompt_label.visible = true
		can_pickup = true
		pickup_target = body
	print("body entered")

func _on_interaction_zone_body_exited(body: Node3D) -> void:
	if body.is_in_group("interactable"):
		print("interactable object exited range")
	if body.is_in_group("pickable") or body.is_in_group("defaceable"):
		if interact_prompt_label:
			interact_prompt_label.text = ""
			interact_prompt_label.visible = false
		can_pickup = false
		pickup_target = null
	print("body exited")

func _on_interaction_zone_area_entered(area: Area3D) -> void:
	if area.is_in_group("danger_zone"):
		print("Danger entered!")
	if area.is_in_group("killable"):
		if interact_prompt_label and PICKABLES["Scalpel"] > 0:
			interact_prompt_label.text = "Kill him {press E}"
			interact_prompt_label.visible = true
			can_kill = true
			kill_target = area.get_parent()
			print("KILL HIM!")
	if area.is_in_group("interactable"):
		if interact_prompt_label:
			interact_prompt_label.text = "open doors {press E}"
			interact_prompt_label.visible = true
		can_interact = true
		interact_target = area.get_parent()
		print("interactable area in range")
	print("area entered")

func _on_interaction_zone_area_exited(area: Area3D) -> void:
	if area.is_in_group("danger_zone"):
		print("Escaped danger")
	if area.is_in_group("killable"):
		if interact_prompt_label:
			interact_prompt_label.text = ""
			interact_prompt_label.visible = false
			can_kill = false
			kill_target = null
			print("cant kill him anymore")
	if area.is_in_group("interactable"):
		if interact_prompt_label:
			interact_prompt_label.text = ""
			interact_prompt_label.visible = false
		can_interact = false
		interact_target = null

		print("area exited")

func _on_aggression_changed(factor: float) -> void:
	aggression = factor
	if PICKABLES["Mask"] != 0:
		var mask_transition = int(MAX_MASK_TRANSITIONS - ceil(factor * MAX_MASK_TRANSITIONS))
		print("mask transition: ", mask_transition)
		PICKABLES["Mask"] = int(mask_transition)
		if GameManager:
			GameManager.emit_signal("mask_progress_changed", mask_transition)

	if PICKABLES["Doctor"]:
		if GameManager:
			GameManager.stop_timer_doctor()
		

		
