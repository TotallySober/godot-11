extends Node

func _ready():
	pass




func _on_HostButton_pressed():
	ConnectionManager.on_host_game()


func _on_JoinButton_pressed():
	var ip = $Panel/JoinRect/IPAdress.text
	ConnectionManager.on_join_game(ip)
