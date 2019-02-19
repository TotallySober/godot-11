extends Area2D

# Has the wallet already been taken ? This variable is only used by the server
var already_took = false 

func _ready():
	#on start, we inform that the owner of this object is the server (id: 1)
	set_network_master(1)

# When the wallet collides with something
func _on_Wallet_body_entered( body ):
	# If this code is executed on the side of the player who has made the collision
	if body.is_network_master():
		#Inform the server that the player (identified by the path of its character) wants to take the object
		rpc("master_pickup", body.get_path())

# Function called by the taker of the object
master func master_pickup(taker_path):
	if not already_took:
		already_took = true
		# Inform every player that the wallet has been taken by the character identified by taker_path
		rpc("sync_pickup", taker_path)

sync func syng_pickup(taker_path):
	# Get the node at the path taker_path
	var taker = get_node(taker_path)
	# Apply the effect to the wallet
	taker.restore_life()
	queue_free()