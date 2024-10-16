extends Node2D

@export var next_scene: String
@export var level := "1"


func _ready():
	if level == "-1":
		level = "16"
	$Camera/pause_menu/Label.text = "Stage " + level
	$AnimationPlayer.play("start")

func _process(delta):
	if $level/Player.position == $level/Door.position:
		get_node("Camera/Animation").play("in-win")
		get_node("Camera/pasue_button").visible = false
		get_node("Camera/GPUParticles2D").restart()
		if GameManager.stage < int(level) + 1:
			GameManager.stage = int(level) + 1
			GameManager.data_save()
		get_tree().paused = true

func _input(event):
	if event.is_action_pressed("Replay"):
		get_node("AnimationPlayer").play("end")
		Change.change(0.7)
		await get_tree().create_timer(0.7).timeout
		get_tree().reload_current_scene()
		

