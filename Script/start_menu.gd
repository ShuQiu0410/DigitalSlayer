extends Control

@onready var setting_menu = preload("res://Scene/setting_menu.tscn")

func _on_texture_button_button_down():
	get_tree().quit()
	
func _on_how_to_play_pressed():
	$how_to_play.visible = true

func _on_settings_pressed():
	$setting_menu.visible = true

func _on_play_pressed():
	$stage_menu.visible = true
