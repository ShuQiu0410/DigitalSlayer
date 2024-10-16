extends Control



func _on_texture_button_pressed():
	get_owner().get_node("Animation").play("in")
	self.visible = false
	get_tree().paused = true
