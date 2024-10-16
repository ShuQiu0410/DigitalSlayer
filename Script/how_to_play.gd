extends Control



func _on_button_2_pressed():
	self.visible = false


func _on_up_pressed():
	$P1.visible = false
	$P2.visible = true


func _on_down_pressed():
	$P2.visible = false
	$P1.visible = true
