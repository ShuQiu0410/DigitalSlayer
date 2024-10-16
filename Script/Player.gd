extends Node2D

signal trap

@export var number = 0
@export var SPEED = 0.01
@onready var tilemap = $"../TileMap"
@onready var label = $Label
@onready var anima = $AnimatedSprite2D
@onready var enemy = preload("res://Scene/object/enemy.tscn")
@onready var trap_ = preload("res://Scene/object/trap.tscn")
@onready var magic = preload("res://Scene/object/magic_circle.tscn")
@onready var god = preload("res://Scene/object/artifact.tscn")
var do_list_array :=[]
var do_list = {
	"tar_dic" : {
		"pos" :-1,
		"id" :-1,
		"num" :-1,
	},
	"player_dic" : {
		"pos" :-1,
		"num" :-1,
	},
}
var do_index = 0
var astra_grid :AStarGrid2D
var prass := false
var curret_id_path :Array[Vector2i]
var is_action := false
var playing := false

func _ready():
	astra_grid = AStarGrid2D.new()
	anima.play("default")
	astra_grid.region = tilemap.get_used_rect() #從tilemap導入參數
	astra_grid.cell_size = Vector2(64,64)
	astra_grid.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER #斜角X
	astra_grid.update() #更新
	label.text = str(number)
	
	for x in tilemap.get_used_rect().size.x:
		for y in tilemap.get_used_rect().size.y:
			var tile_pos = Vector2i(
				x,
				y
			) #遍歷每個瓦塊
			var tile_data = tilemap.get_cell_tile_data(1,tile_pos)
			
			if tile_data == null or tile_data.get_custom_data("walk") == false:
				astra_grid.set_point_solid(tile_pos, true) #設定為不可行走
	
func _process(delta):
	#print($FX_buff.self_modulate.a)
	if Input.is_action_just_pressed("Undo"):
		undo()
	movement()
	
func _physics_process(delta):
	#click_movement()
	pass
	

func click_movement():
	if curret_id_path.is_empty():
		return
	var target_pos = tilemap.map_to_local(curret_id_path.front()) * 4 - Vector2(32,32)
	global_position = global_position.move_toward(target_pos,5)
	if global_position == target_pos:
		curret_id_path.pop_front()

func _input(event):
	if event.is_action_pressed("tap") == false:
		return
	var id_path = astra_grid.get_id_path(
		tilemap.local_to_map(global_position)/4,
		tilemap.local_to_map(get_global_mouse_position()/4)
	).slice(1) #cut target path array
	curret_id_path = id_path
	#print(id_path)

func FX_buff():
	$FX_buff.visible = true
	$FX_buff.self_modulate.a = 0
	$FX_buff.play("BUFF")
	$SFX_enemy.play()
	$AnimationPlayer.play("fx buff")
	await get_tree().create_timer(0.7).timeout
	$FX_buff.visible = false

	
func movement()->void:
	if not is_action:
		if Input.is_action_just_pressed("ui_down"):
			if $down.get_collider() != null:
				if $down.get_collider().is_in_group("Enemy"):
					if $down.get_collider().get_owner().number < number:
						write_do_list(
							Vector2(position.x,position.y + 64),
							1,
							$down.get_collider().get_owner().number,
							Vector2(position),
							number,
							$down.get_collider().get_owner().skin_type
						)
						var tar_num = $down.get_collider().get_owner().number
						is_action = true
						$down.get_collider().get_owner().dead()
						await get_tree().create_timer(0.7).timeout
						display(number + tar_num, 1)
						$FX.visible = true
						$SFX_enemy.play()
						is_action = false
						$FX.play("buff")
						label.text = str(number)
						await get_tree().create_timer(0.5).timeout
						$FX.visible = false
						print(do_list)
						#self.position.y += 64
				
				elif $down.get_collider().is_in_group("Trap"):
					if $down.get_collider().get_owner().is_used:
						write_do_list(
							-1,
							-1,
							-1,
							Vector2(position),
							number
						)
						self.position.y += 64
						$SFX_step.play()
					elif $down.get_collider().get_owner().number < number:
						is_action = true
						write_do_list(
							Vector2(position.x,position.y + 64),
							2,
							$down.get_collider().get_owner().number,
							Vector2(position),
							number
						)
						display(number - $down.get_collider().get_owner().number, -1)
						self.position.y += 64
						$SFX_step.play()
						$down.get_collider().get_owner().is_used = true
						emit_signal("trap")
						is_action = false
						label.text = str(number)
						
				elif $down.get_collider().is_in_group("Magic"):
					if $down.get_collider().get_owner().number < number:
						is_action = true
						write_do_list(
							Vector2(position.x,position.y + 64),
							3,
							$down.get_collider().get_owner().number,
							Vector2(position),
							number
						)
						display(number / $down.get_collider().get_owner().number, -1)
						self.position.y += 64
						$SFX_step.play()
						$FX.visible = true
						$FX.play("debuff")
						$down.get_collider().get_owner().queue_free()
						$SFX_magic.play()
						is_action = false
						label.text = str(number)
						await get_tree().create_timer(1).timeout
						$FX.visible = false 
						
				elif $down.get_collider().is_in_group("God"):
					is_action = true
					write_do_list(
							Vector2(position.x,position.y + 64),
							4,
							$down.get_collider().get_owner().number,
							Vector2(position),
							number
						)
					display(number * $down.get_collider().get_owner().number, 1)
					self.position.y += 64
					$SFX_step.play()
					FX_buff()
					$down.get_collider().get_owner().queue_free()
					is_action = false
					label.text = str(number)
					
			elif not $down.is_colliding():
				write_do_list(
					-1,
					-1,
					-1,
					Vector2(position),
					number
				)
				self.position.y += 64
				$SFX_step.play()
		
		elif Input.is_action_just_pressed("ui_up"):
			if $up.get_collider() != null:
				if $up.get_collider().is_in_group("Enemy"):
					if $up.get_collider().get_owner().number < number:
						is_action = true
						write_do_list(
							Vector2(position.x,position.y - 64),
							1,
							$up.get_collider().get_owner().number,
							Vector2(position),
							number,
							$up.get_collider().get_owner().skin_type
						)
						var tar_num = $up.get_collider().get_owner().number
						$up.get_collider().get_owner().dead()
						await get_tree().create_timer(0.7).timeout
						display(number + tar_num, 1)
						$FX.visible = true
						$SFX_enemy.play()
						is_action = false
						$FX.play("buff")
						label.text = str(number)
						await get_tree().create_timer(0.5).timeout
						$FX.visible = false
						#self.position.y -= 64

				elif $up.get_collider().is_in_group("Trap"):
					if $up.get_collider().get_owner().is_used:
						write_do_list(
							-1,
							-1,
							-1,
							Vector2(position),
							number
						)
						self.position.y -= 64
						$SFX_step.play()
					elif $up.get_collider().get_owner().number < number :
						is_action = true
						write_do_list(
							Vector2(position.x,position.y - 64),
							2,
							$up.get_collider().get_owner().number,
							Vector2(position),
							number
						)
						display(number - $up.get_collider().get_owner().number, -1)
						self.position.y -= 64
						$SFX_step.play()
						$up.get_collider().get_owner().is_used = true
						emit_signal("trap")
						is_action = false
						label.text = str(number)
						
				elif $up.get_collider().is_in_group("Magic"):
					if $up.get_collider().get_owner().number < number:
						is_action = true
						write_do_list(
							Vector2(position.x,position.y - 64),
							3,
							$up.get_collider().get_owner().number,
							Vector2(position),
							number
						)
						display(number / $up.get_collider().get_owner().number, -1)
						self.position.y -= 64
						$SFX_step.play()
						$FX.visible = true
						$FX.play("debuff")
						$up.get_collider().get_owner().queue_free()
						is_action = false
						label.text = str(number)
						$SFX_magic.play()
						await get_tree().create_timer(1).timeout
						$FX.visible = false 
						
				elif $up.get_collider().is_in_group("God"):
					is_action = true
					write_do_list(
						Vector2(position.x,position.y - 64),
						4,
						$up.get_collider().get_owner().number,
						Vector2(position),
						number
					)
					display(number * $up.get_collider().get_owner().number, 1)
					self.position.y -= 64
					$SFX_step.play()
					FX_buff()
					$up.get_collider().get_owner().queue_free()
					is_action = false
					label.text = str(number)
					
			elif not $up.is_colliding():
				write_do_list(
					-1,
					-1,
					-1,
					Vector2(position),
					number
				)
				self.position.y -= 64
				$SFX_step.play()

		elif Input.is_action_just_pressed("ui_right"):
			if $right.get_collider() != null:
				if $right.get_collider().is_in_group("Enemy"):
					if $right.get_collider().get_owner().number < number:
						is_action = true
						write_do_list(
							Vector2(position.x + 64,position.y),
							1,
							$right.get_collider().get_owner().number,
							Vector2(position),
							number,
							$right.get_collider().get_owner().skin_type
						)
						var tar_num = $right.get_collider().get_owner().number
						$right.get_collider().get_owner().dead()
						await get_tree().create_timer(0.7).timeout
						display(number + tar_num, 1)
						$FX.visible = true
						$SFX_enemy.play()
						is_action = false
						$FX.play("buff")
						await get_tree().create_timer(0.5).timeout
						$FX.visible = false
						#self.position.x += 64

				elif $right.get_collider().is_in_group("Trap"):
					if $right.get_collider().get_owner().is_used:
						write_do_list(
							-1,
							-1,
							-1,
							Vector2(position),
							number
						)
						self.position.x += 64
						$SFX_step.play()
					elif $right.get_collider().get_owner().number < number :
						is_action = true
						write_do_list(
							Vector2(position.x + 64,position.y),
							2,
							$right.get_collider().get_owner().number,
							Vector2(position),
							number
						)
						display(number - $right.get_collider().get_owner().number, -1)
						self.position.x += 64
						$SFX_step.play()
						$right.get_collider().get_owner().is_used = true
						emit_signal("trap")
						is_action = false
						
				elif $right.get_collider().is_in_group("Magic"):
					if $right.get_collider().get_owner().number < number:
						is_action = true
						write_do_list(
							Vector2(position.x + 64,position.y),
							3,
							$right.get_collider().get_owner().number,
							Vector2(position),
							number
						)
						display(number / $right.get_collider().get_owner().number, -1)
						self.position.x += 64
						$SFX_step.play()
						$FX.visible = true
						$FX.play("debuff")
						$right.get_collider().get_owner().queue_free()
						is_action = false
						$SFX_magic.play()
						await get_tree().create_timer(1).timeout
						$FX.visible = false 
						
				elif $right.get_collider().is_in_group("God"):
					is_action = true
					write_do_list(
						Vector2(position.x + 64,position.y),
						4,
						$right.get_collider().get_owner().number,
						Vector2(position),
						number
					)
					display(number * $right.get_collider().get_owner().number, 1)
					self.position.x += 64
					$SFX_step.play()
					FX_buff()
					$right.get_collider().get_owner().queue_free()
					is_action = false

			elif not $right.is_colliding():
				write_do_list(
					-1,
					-1,
					-1,
					Vector2(position),
					number
				)
				self.position.x += 64
				$SFX_step.play()

		elif Input.is_action_just_pressed("ui_left"):
			if $left.get_collider() != null:
				if $left.get_collider().is_in_group("Enemy"):
					if $left.get_collider().get_owner().number < number:
						is_action = true
						write_do_list(
							Vector2(position.x - 64,position.y),
							1,
							$left.get_collider().get_owner().number,
							Vector2(position),
							number,
							$left.get_collider().get_owner().skin_type
						)
						var tar_num = $left.get_collider().get_owner().number
						$left.get_collider().get_owner().dead()
						await get_tree().create_timer(0.7).timeout
						display(number + tar_num, -1)
						$FX.visible = true
						$SFX_enemy.play()
						is_action = false
						$FX.play("buff")
						label.text = str(number)
						await get_tree().create_timer(0.5).timeout
						$FX.visible = false
						#self.position.x -= 64

				elif $left.get_collider().is_in_group("Trap"):
					if $left.get_collider().get_owner().is_used:
						write_do_list(
							-1,
							-1,
							-1,
							Vector2(position),
							number
						)
						self.position.x -= 64
						$SFX_step.play()
					elif $left.get_collider().get_owner().number < number:
						is_action = true
						write_do_list(
							Vector2(position.x - 64,position.y),
							2,
							$left.get_collider().get_owner().number,
							Vector2(position),
							number
						)
						display(number - $left.get_collider().get_owner().number, -1)
						self.position.x -= 64
						$SFX_step.play()
						$left.get_collider().get_owner().is_used = true
						emit_signal("trap")
						is_action = false
						label.text = str(number)

				elif $left.get_collider().is_in_group("Magic"):
					if $left.get_collider().get_owner().number < number:
						is_action = true
						write_do_list(
							Vector2(position.x - 64,position.y),
							3,
							$left.get_collider().get_owner().number,
							Vector2(position),
							number
						)
						display(number / $left.get_collider().get_owner().number, -1)
						self.position.x -= 64
						$SFX_step.play()
						$FX.visible = true
						$FX.play("debuff")
						$left.get_collider().get_owner().queue_free()
						is_action = false
						label.text = str(number)
						$SFX_magic.play()
						await get_tree().create_timer(1).timeout
						$FX.visible = false 
				
				elif $left.get_collider().is_in_group("God"):
					is_action = true
					write_do_list(
						Vector2(position.x - 64,position.y),
						4,
						$left.get_collider().get_owner().number,
						Vector2(position),
						number
					)
					display(number * $left.get_collider().get_owner().number, 1)
					self.position.x -= 64
					$SFX_step.play()
					FX_buff()
					$left.get_collider().get_owner().queue_free()
					is_action = false
					label.text = str(number)
				
			elif not $left.is_colliding():
				write_do_list(
					-1,
					-1,
					-1,
					Vector2(position),
					number
				)
				self.position.x -= 64
				$SFX_step.play()

func undo():
	if do_index>0:
		position = do_list_array[do_index-1]["player_dic"]["pos"]
		number = do_list_array[do_index-1]["player_dic"]["num"]
		label.text = str(number)#player undo
		if do_list_array[do_index-1]["tar_dic"]["id"] == 1:
			var instance = enemy.instantiate()
			get_owner().get_node("level").add_child(instance)
			instance.position = do_list_array[do_index-1]["tar_dic"]["pos"]
			instance.number = do_list_array[do_index-1]["tar_dic"]["num"]
			instance.skin_type = do_list_array[do_index-1]["tar_dic"]["skin"]
			instance.skin(do_list_array[do_index-1]["tar_dic"]["skin"])
			instance.label.text = str(instance.number)
			#print(do_list_array[do_index-1]["tar_dic"]["skin"])
		elif do_list_array[do_index-1]["tar_dic"]["id"] == 2:
			var instance = trap_.instantiate()
			get_owner().get_node("level").add_child(instance)
			instance.position = do_list_array[do_index-1]["tar_dic"]["pos"]
			instance.number = do_list_array[do_index-1]["tar_dic"]["num"]
			instance.label.text = str(instance.number)
		elif do_list_array[do_index-1]["tar_dic"]["id"] == 3:
			var instance = magic.instantiate()
			get_owner().get_node("level").add_child(instance)
			instance.position = do_list_array[do_index-1]["tar_dic"]["pos"]
			instance.number = do_list_array[do_index-1]["tar_dic"]["num"]
			instance.label.text = str(instance.number)
		elif do_list_array[do_index-1]["tar_dic"]["id"] == 4:
			var instance = god.instantiate()
			get_owner().get_node("level").add_child(instance)
			instance.position = do_list_array[do_index-1]["tar_dic"]["pos"]
			instance.number = do_list_array[do_index-1]["tar_dic"]["num"]
			instance.label.text = str(instance.number)
		do_index -= 1
		do_list_array.pop_back()
	pass

func write_do_list(tar_pos,id,tar_num,player_pos,player_num,skin = 1):
	do_list = {
		"tar_dic" : {
			"skin" = skin,
			"pos" = tar_pos,
			"id" = id,
			"num" = tar_num,
		},
		"player_dic" : {
			"pos" = player_pos,
			"num" = player_num,
		},
	}
	do_list_array.append(do_list)
	#print(do_list_array[do_index])
	do_index += 1

func display(input, type):
	playing = false
	var cur_num = number
	var tar_num = input
	number = tar_num
	await get_tree().create_timer(0.03).timeout
	playing = true
	if type == 1:
		for i in range( cur_num, tar_num + 1, max((tar_num - cur_num) / 30 , type)):
			$Label.text = str(i)
			await get_tree().create_timer(0.02).timeout
			if not playing:
				break
	elif type == -1:
		for i in range( cur_num, tar_num - 1, min((tar_num - cur_num) / 30, type)):
			$Label.text = str(i)
			await get_tree().create_timer(0.02).timeout
			if not playing:
				break
	else:
		print("ERROR")
	playing = false

func _on_button_button_down():
	undo()
	pass # Replace with function body.
