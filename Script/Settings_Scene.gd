extends Node2D

var  Main_Menu_Scene =  load("res://MainMenu.tscn")

func _on_texture_button_pressed():
	get_tree().change_scene_to_packed(Main_Menu_Scene)
