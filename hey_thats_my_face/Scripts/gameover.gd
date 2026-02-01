extends Control

@onready var play_button = $MenuBox/PlayButton
@onready var quit_button = $MenuBox/QuitButton

func _ready():
	print("GAMEOVER LOADED")
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	play_button.pressed.connect(_on_play_pressed)
	quit_button.pressed.connect(_on_quit_pressed)

func _on_play_pressed():
	print("RESTART GAME")
	get_tree().change_scene_to_file("res://Scenes/Level/hospital.tscn")

func _on_quit_pressed():
	print("QUIT GAME")
	get_tree().quit()
