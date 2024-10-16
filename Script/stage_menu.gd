extends Control

var right = 2
var index = 1
var left = 1

@onready var stage_1 := $"MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer/1"
@onready var stage_2 := $"MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer/5"
@onready var stage_3 := $"MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer2/2"
@onready var stage_4 := $"MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer2/6"
@onready var stage_5 := $"MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer3/3"
@onready var stage_6 := $"MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer3/7"
@onready var stage_7 := $"MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer4/4"
@onready var stage_8 := $"MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer4/8"


func _ready():
	chack()

func chack():
	$TextureButton.visible = true
	$TextureButton2.visible = true
	if index == right:
		$TextureButton.visible = false
	if index == left:
		$TextureButton2.visible = false
	

func _on_button_pressed():
	self.visible = false


func _on_texture_button_pressed():#right
	stage_1.level = str( int(stage_1.level) + 8 )
	stage_2.level = str( int(stage_2.level) + 8 )
	stage_3.level = str( int(stage_3.level) + 8 )
	stage_4.level = str( int(stage_4.level) + 8 )
	stage_5.level = str( int(stage_5.level) + 8 )
	stage_6.level = str( int(stage_6.level) + 8 )
	stage_7.level = str( int(stage_7.level) + 8 )
	stage_8.level = str( int(stage_8.level) + 8 )
	stage_1.show_level()
	stage_2.show_level()
	stage_3.show_level()
	stage_4.show_level()
	stage_5.show_level()
	stage_6.show_level()
	stage_7.show_level()
	stage_8.show_level()
	index += 1
	chack()
	

func _on_texture_button_2_pressed():#left
	stage_1.level = str( int(stage_1.level) - 8 )
	stage_2.level = str( int(stage_2.level) - 8 )
	stage_3.level = str( int(stage_3.level) - 8 )
	stage_4.level = str( int(stage_4.level) - 8 )
	stage_5.level = str( int(stage_5.level) - 8 )
	stage_6.level = str( int(stage_6.level) - 8 )
	stage_7.level = str( int(stage_7.level) - 8 )
	stage_8.level = str( int(stage_8.level) - 8 )
	index -= 1
	stage_1.show_level()
	stage_2.show_level()
	stage_3.show_level()
	stage_4.show_level()
	stage_5.show_level()
	stage_6.show_level()
	stage_7.show_level()
	stage_8.show_level()
	chack()
