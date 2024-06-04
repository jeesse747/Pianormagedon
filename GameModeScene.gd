extends Node2D
var Main_Menu_Scene = load("res://MainMenu.tscn")
var Game_Scene_Random = load("res://Game_Scene_Random.tscn")
var Game_Scene_Melody = load("res://Game_Scene_Melody.tscn")

func _on_texture_button_pressed():
	get_tree().change_scene_to_packed(Game_Scene_Melody)


func _on_random_button_pressed():
	get_tree().change_scene_to_packed(Game_Scene_Random)


func _on_back_button_pressed():
	get_tree().change_scene_to_packed(Main_Menu_Scene)
