extends Control

@onready var anima := $ColorRect/AnimationPlayer

func _ready():
	$ColorRect.color.a = 0

func change(s):
	anima.speed_scale = 1.0/s
	anima.play("zoomIn")
	await get_tree().create_timer(s+0.1).timeout
	anima.play("zoomOut")

func on(s):
	anima.speed_scale = 1.0/s
