extends Node2D

@export var number = 0
@onready var label = $Label
var is_used = false

func _ready():
	label.text = str(number)
