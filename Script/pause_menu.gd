extends Control

@export var stage := 0

func _on_exit_pressed():
	get_tree().paused = false
	get_owner().get_node("Animation").play("out")
	get_node("../../AnimationPlayer").play("end")
	Change.change(0.7)
	await get_tree().create_timer(0.7).timeout
	get_tree().change_scene_to_file("res://Scene/start_menu.tscn")

func _on_re_pressed():
	get_tree().paused = false
	get_owner().get_node("Animation").play("out")
	get_node("../../AnimationPlayer").play("end")
	Change.change(0.7)
	await get_tree().create_timer(0.7).timeout
	get_tree().reload_current_scene()

func _on_go_pressed():
	get_owner().get_node("Animation").play("out")
	get_owner().get_node("pasue_button").visible = true
	get_tree().paused = false
