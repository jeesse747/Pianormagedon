extends Node2D
var Main_Menu_Scene = load("res://Scenes/MainMenu.tscn")
var Game_Scene_Random_easy= load("res://Scenes/Game_Scene_Random_easy.tscn")
var Game_Scene_Random_normal = load("res://Scenes/Game_Scene_Random_normal.tscn")
var Game_Scene_Random_hard = load("res://Scenes/Game_Scene_Random_hard.tscn")



func _on_back_button_pressed():
	get_tree().change_scene_to_packed(Main_Menu_Scene)

func _on_easy_button_pressed():
	get_tree().change_scene_to_packed(Game_Scene_Random_easy)
	AudioPlayer.stop()
	
func _on_normal_button_pressed():
	get_tree().change_scene_to_packed(Game_Scene_Random_normal)
	AudioPlayer.stop()
	


func _on_hard_button_pressed():
	get_tree().change_scene_to_packed(Game_Scene_Random_hard)
	AudioPlayer.stop()
