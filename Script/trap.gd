extends Node2D

@export var number = 0
@onready var label = $Label
@onready var anima = $AnimatedSprite2D
@onready var trap_used_img = load("res://Image/Trap1/peaks_3 ex.png")
var is_used = false
var sound_played := false
var queue = 0
func _ready():
	label.text = str(number)
	get_parent().get_node("Player").trap.connect(trap_used)
	
func trap_used():
	if is_used:
		number = 0
		$Label.visible = false
		self.get_node("Sprite2D").texture = trap_used_img
		if not queue:
			$StaticBody2D.queue_free()
			queue += 1
		if not sound_played:
			$SFX.play()
			sound_played = true

