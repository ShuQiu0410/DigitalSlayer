extends Control

var line = 1

func _ready():
	$TabContainer/Audio/Master/Master.value = GameManager.Data.vol_master
	$TabContainer/Audio/SFX/SFX.value = GameManager.Data.vol_sfx
	$TabContainer/Audio/Music/Music.value = GameManager.Data.vol_music

func _on_master_value_changed(value):
	var bus = AudioServer.get_bus_index("Master")
	if value > $TabContainer/Audio/Master/Master.min_value:
		AudioServer.set_bus_mute(bus, false)
		AudioServer.set_bus_volume_db(bus, value)
	else:
		AudioServer.set_bus_mute(bus, true)
	GameManager.Data.vol_master = value
	GameManager.data_save()
	




func _on_button_pressed():
	self.visible = false


func _on_sfx_value_changed(value):
	var bus = AudioServer.get_bus_index("SFX")
	if value > $TabContainer/Audio/SFX/SFX.min_value:
		AudioServer.set_bus_mute(bus, false)
		AudioServer.set_bus_volume_db(bus, value)
	else:
		AudioServer.set_bus_mute(bus, true)
	GameManager.Data.vol_sfx = value
	GameManager.data_save()



func _on_music_value_changed(value):
	var bus = AudioServer.get_bus_index("BGM")
	if value > $TabContainer/Audio/Music/Music.min_value:
		AudioServer.set_bus_mute(bus, false)
		AudioServer.set_bus_volume_db(bus, value)
	else:
		AudioServer.set_bus_mute(bus, true)
	GameManager.Data.vol_music = value
	GameManager.data_save()
	
func _input(event):
	if event.is_action_pressed("rollingUp"):
		line += 1
		$TabContainer/Cridit/RichTextLabel.scroll_to_line(line)
	elif event.is_action_pressed("rollingDown"):
		line -= 1
		$TabContainer/Cridit/RichTextLabel.scroll_to_line(line)
