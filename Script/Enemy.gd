extends Node2D

@export var number = 0
@export var SPEED = 2.1
@export var skin_type = 1
@onready var label = $Label
@onready var anima = $AnimatedSprite2D
@onready var player = get_parent().get_node("Player")
var buff_fly = 0

func _ready():
	#print(self.name,get_parent())
	#print(self.name,get_owner())
	label.text = str(number)
	skin(skin_type)

func _physics_process(delta):
	if buff_fly == 1:
		global_position.x += 1 * SPEED;
	if buff_fly == 2:
		global_position.x -= 1 * SPEED;
		#print(global_position.x)
	if buff_fly == 3:
		global_position.y += 1 * SPEED;
	if buff_fly == 4:
		global_position.y -= 1 * SPEED;
		
	
func skin(type):
	match type:
		1:
			anima.play("skin1")
		2:
			anima.play("skin2")
		3:
			anima.play("skin3")

func dead():
	#print("adsdawd")
	$SFX.play()
	$hit.play("default")
	await get_tree().create_timer(0.35).timeout
	anima.visible = false
	$buff.play("default")
	var player_pos = player.global_position
	$buff.visible = true
	var self_pos = global_position
	if player_pos.x > self_pos.x:
		buff_fly = 1
		$buff.rotation = PI
	elif player_pos.x < self_pos.x:
		buff_fly = 2
		$buff.rotation = 0
	elif player_pos.y > self_pos.y:
		buff_fly = 3
		$buff.rotation = PI / 2 * 3
	elif player_pos.y < self_pos.y:
		buff_fly = 4
		$buff.rotation = PI / 2
	$Label.visible = false
	
	await get_tree().create_timer(0.35).timeout
	
	queue_free()
