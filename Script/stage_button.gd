extends Button

@export var level := "0"
var target

func _ready():
	show_level()
	
	
func _on_pressed():
	Change.change(0.25)
	await get_tree().create_timer(0.25).timeout
	get_tree().change_scene_to_packed(target)

func show_level():
	$Label.text = level
	if GameManager.stage >= int(level):
		$TextureRect.visible = false
		self.disabled = false
	else:
		$TextureRect.visible = true
		self.disabled = true
	target = load("res://Scene/level_" + level + ".tscn")
