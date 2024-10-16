extends Node

var stage:int
var Data:Resource

func _ready():
	if not ResourceLoader.exists("user://save.tres"):
		print("caeated" , Data)
		Data = level_save.new()
		Data.level = 1
		data_save()
	else:
		Data = ResourceLoader.load("user://save.tres")
		
	stage = Data.level
		
func data_save():
	if Data.level < GameManager.stage:
		Data.level = GameManager.stage
		ResourceSaver.save(Data,"user://save.tres")
