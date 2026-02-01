extends Control

@onready var play_button = $PlayButton
@onready var test_button = $TestButton
@onready var quit_button = $QuitButton

func _ready():
	print("MENU CARICATO")
	play_button.pressed.connect(_on_play_pressed)
	test_button.pressed.connect(_on_test_pressed)
	quit_button.pressed.connect(_on_quit_pressed)

func _on_play_pressed():
	print("PLAY OK")
	get_tree().change_scene_to_file("res://Scenes/Level/hospital.tscn")

func _on_test_pressed():
	print("TEST OK")
	get_tree().change_scene_to_file("res://test_scene.tscn")

func _on_quit_pressed():
	print("QUIT OK")
	get_tree().quit()
