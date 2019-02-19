extends Control

var _player_name = ""
var Network

func _ready():
	Network = get_node("/root/Network")
	

func _on_TextField_text_changed(new_text):
	_player_name = new_text

func _on_CreateButton_pressed():
	print("create game")
	print("Name: " + _player_name)
	if _player_name == "":
		return
		print("returned")
	
	Network.create_server(_player_name)
	print("created server")
	_load_game()
	print("loaded game")

func _on_JoinButton_pressed():
	print("join game")
	if _player_name == "":
		return
	Network.connect_to_server(_player_name)
	_load_game()

func _load_game():
	get_tree().change_scene("res://World.tscn")
	print("load game")
