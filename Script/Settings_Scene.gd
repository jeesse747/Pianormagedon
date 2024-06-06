extends Node2D

var  Main_Menu_Scene =  load("res://Scenes/MainMenu.tscn")
var Background = AudioServer.get_bus_index("Bg_Bus")




func _ready():
	var current_volume = AudioServer.get_bus_volume_db(Background)
	$Sprite2D/LightSlider.value= CmScript._getCurrentColor().r
	$Sprite2D/VolSlider.value = current_volume
	if current_volume == -15.0:
		AudioServer.set_bus_mute(Background, true)
	else:
		AudioServer.set_bus_mute(Background, false)
	
	

func _on_texture_button_pressed():
	get_tree().change_scene_to_packed(Main_Menu_Scene)


func _on_down_vol_pressed():
	var current_volume = AudioServer.get_bus_volume_db(Background)
	var new_volume = current_volume - 1
	if new_volume < -15:
		new_volume = -15
		
	AudioServer.set_bus_volume_db(Background, new_volume)
	$Sprite2D/VolSlider.value = new_volume
	



func _on_up_vol_pressed():
	var current_volume = AudioServer.get_bus_volume_db(Background)
	var new_volume = current_volume + 1
	if new_volume > -5:
		new_volume = -5
	AudioServer.set_bus_volume_db(Background, new_volume)
	$Sprite2D/VolSlider.value = new_volume
	


func _on_light_slider_value_changed(value):
	CmScript._setColor(value)


func _on_up_light_pressed():
	var current_light = CmScript._getCurrentColor().r
	var new_light = current_light + 0.08
	if new_light > 1:
		new_light = 1
	CmScript._setColor(new_light)
	$Sprite2D/LightSlider.value = new_light



func _on_down_light_pressed():
	var current_light = CmScript._getCurrentColor().r
	var new_light = current_light - 0.08
	if new_light < 0.2:
		new_light = 0.2
	CmScript._setColor(new_light)
	$Sprite2D/LightSlider.value = new_light


func _on_vol_slider_value_changed(value):

	AudioServer.set_bus_volume_db(Background, value)
	if	value == -15:
		AudioServer.set_bus_mute(Background, true)
	else:
		AudioServer.set_bus_mute(Background, false)
