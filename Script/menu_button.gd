extends TextureButton



func _on_button_down():
	$Label.position.y += 17
	$Label.label_settings.font_color = Color(0.7, 0.7, 0.7, 1)



func _on_button_up():
	$Label.position.y -= 17
	$Label.label_settings.font_color = Color(1, 1, 1, 1)
