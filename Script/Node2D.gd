extends Node2D

var Game_Mode_Scene = load("res://GameModeScene.tscn")



func _on_back_button_pressed():
	get_tree().change_scene_to_packed(Game_Mode_Scene)
