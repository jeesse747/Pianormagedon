extends Node2D
var Main_Menu_Scene = load("res://Scenes/MainMenu.tscn")
var Game_mode_Scene = load("res://Scenes/GameModeScene.tscn")
@onready var score_label = $ScoreLabel

func _ready():
	print(Global.score)
	score_label.text = str(Global.score)

func _on_home_button_pressed():
	get_tree().change_scene_to_packed(Main_Menu_Scene)
	AudioPlayer.play()

func _on_play_again_button_pressed():
	get_tree().change_scene_to_packed(Game_mode_Scene)


