extends KinematicBody

var current_camera = 0
var camera_angle = 0
var mouse_sensitivity = 0.5
var camera_change = Vector2()

var velocity = Vector3()
var direction = Vector3()

#walk variables
var gravity = -9.8 * 3
const MAX_SPEED = 20
const MAX_RUNNING_SPEED = 30
const ACCEL = 2
const DEACCEL = 6

#jumping
var jump_height = 15
var in_air = 0
var has_contact = false

var above_head
var label
var camera

func _ready():
	get_node("Head/Crosshair").position.x = get_viewport().size.x / 2
	get_node("Head/Crosshair").position.y = get_viewport().size.y / 2
	
	above_head = get_node("CollisionShape/Position3D")
	label = get_node("CanvasLayer/Label")
	camera = get_node("Head/Camera")
	
	var offset = Vector2(label.get_size().x/2, 0)
	
	label.set_position(camera.unproject_position(above_head.get_translation()) - offset)
	pass

func _physics_process(delta):
	aim()
	walk(delta)

func _input(event):
	if event is InputEventMouseMotion:
		camera_change = event.relative
		
func walk(delta):
	# reset the direction of the player
	direction = Vector3()
	
	# get the rotation of the camera
	var aim = $Head/Camera.get_global_transform().basis
	# check input and change direction
	if Input.is_action_pressed("move_forward"):
		direction -= aim.z
	if Input.is_action_pressed("move_backward"):
		direction += aim.z
	if Input.is_action_pressed("move_left"):
		direction -= aim.x
	if Input.is_action_pressed("move_right"):
		direction += aim.x
	direction.y = 0
	direction = direction.normalized()
	
	var temp_velocity = velocity
	temp_velocity.y = 0
	
	var speed
	if Input.is_action_pressed("move_sprint"):
		speed = MAX_RUNNING_SPEED
	else:
		speed = MAX_SPEED
	
	# where would the player go at max speed
	var target = direction * speed
	
	var acceleration
	if direction.dot(temp_velocity) > 0:
		acceleration = ACCEL
	else:
		acceleration = DEACCEL
	
	# calculate a portion of the distance to go
	temp_velocity = temp_velocity.linear_interpolate(target, acceleration * delta)
	
	velocity.x = temp_velocity.x
	velocity.z = temp_velocity.z
	
	if has_contact and Input.is_action_just_pressed("jump"):
		velocity.y = jump_height
		has_contact = false
	
	# move
	velocity = move_and_slide(velocity, Vector3(0, 1, 0))
	print($".".translation)


func aim():
	if camera_change.length() > 0:
		$Head.rotate_y(deg2rad(-camera_change.x * mouse_sensitivity))

		var change = -camera_change.y * mouse_sensitivity
		if change + camera_angle < 90 and change + camera_angle > -40:
			$Head/Camera.rotate_x(deg2rad(change))
			camera_angle += change
		camera_change = Vector2()

func initPlayerVariables(nickname, start_position, is_slave):
	label.text = nickname
	velocity = start_position
	if is_slave:
		print("is slave: " + str(is_slave))