extends StaticBody3D


func _ready() -> void:
	add_to_group("defaceable")
	$FaceOn.visible = true
	$FaceOff.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func handle_face():
	$FaceOn.visible = false
	$FaceOff.visible = true
	
