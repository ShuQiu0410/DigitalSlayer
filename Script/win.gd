extends Control

var level

func _ready():
	level = int(get_node("../..").level)
	

func _on_exit_pressed():
	get_owner().get_node("Animation").play("out-win")
	get_node("../../AnimationPlayer").play("end")
	Change.change(0.7)
	await get_tree().create_timer(0.7).timeout
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scene/start_menu.tscn")


func _on_go_pressed():
	if level == -1:
		get_owner().get_node("Animation").play("out-win")
		get_node("../../AnimationPlayer").play("end")
		Change.change(0.7)
		await get_tree().create_timer(0.7).timeout
		get_tree().paused = false
		get_tree().change_scene_to_file("res://Scene/thanks.tscn")
	else:
		get_owner().get_node("Animation").play("out-win")
		get_node("../../AnimationPlayer").play("end")
		Change.change(0.7)
		await get_tree().create_timer(0.7).timeout
		get_tree().paused = false
		get_tree().change_scene_to_file("res://Scene/level_" + str(level+1) + ".tscn")


func _on_re_pressed():
	get_owner().get_node("Animation").play("out-win")
	get_node("../../AnimationPlayer").play("end")
	Change.change(0.7)
	await get_tree().create_timer(0.7).timeout
	get_tree().paused = false
	get_tree().reload_current_scene()
