extends RigidBody2D

var speed = 30
var rotation_speed = 100
var max_speed = 50

# Note the slave keyword, this variable is intended to be setted by others
slave var slave_position = Vector2()
slave var slave_rotation = 0

func _ready():
	var x_position = get_viewport_rect().size.x / 2
	var y_position = get_viewport_rect().size.y / 2
	position = Vector2(x_position, y_position)

func _input(event):
	if Input.is_action_just_pressed("restart"):
		get_tree().reload_current_scene()
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()

# Called every frame
func _process(delta):
	if is_network_master():
		# If the user presses the key up, then go forward
		if Input.is_action_pressed("ui_up"):
			add_force(Vector2(0,0), Vector2(cos(rotation), sin(rotation)) * speed)
		
		# Limit the velocity to max_speed
		if get_linear_velocity().length() > max_speed:
			set_linear_velocity(get_linear_velocity().normalized() * max_speed)
		
		# If the user presses left, then rotate left
		if Input.is_action_pressed("ui_left"):
			set_angular_velocity(- rotation_speed * delta)
		
		# If the user presses right. then rotate right
		if Input.is_action_pressed("ui_right"):
			set_angular_velocity(rotation_speed * delta)
		
		
		# The master informs about the new position and rotation
		rset_unreliable("slave_position", position)
		rset_unreliable("slave_rotation", rotation)
	else:
		# The slaves get the received position and update it locally
		position = slave_position
		rotation = slave_rotation
	pass