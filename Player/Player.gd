extends KinematicBody

onready var Camera = $Pivot/Camera

onready var Aim = $Pivot/Camera/AimCast
onready var Pivot = $Pivot

onready var Gunshot = $Pivot/Gun/Gunshot

var Counter = null
var counter = 3

var gravity = -30
var max_speed = 8
var mouse_sensitivity = 0.002
var mouse_range = 1.2

var velocity = Vector3()

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	if Global.which_player == 1:
		$MeshInstance.get_surface_material(0).albedo_color = Color8(34,139,230)
	else:
		$MeshInstance.get_surface_material(0).albedo_color = Color8(250,82,82)
	
func _process(delta):
	if counter <= 0:
		get_tree().change_scene("res://UI/EndScreen.tscn")

func get_input():
	var input_dir = Vector3()
	if Input.is_action_pressed("forward"):
		input_dir += -Camera.global_transform.basis.z
	if Input.is_action_pressed("back"):
		input_dir += Camera.global_transform.basis.z
	if Input.is_action_pressed("left"):
		input_dir += -Camera.global_transform.basis.x
	if Input.is_action_pressed("right"):
		input_dir += Camera.global_transform.basis.x
	input_dir = input_dir.normalized()
	return input_dir

func _unhandled_input(event):
	if event is InputEventMouseMotion:
		$Pivot.rotate_x(-event.relative.y * mouse_sensitivity)
		rotate_y(-event.relative.x * mouse_sensitivity)
		$Pivot.rotation.x = clamp($Pivot.rotation.x, deg2rad(-90), deg2rad(90))

func _physics_process(delta):
	velocity.y += gravity * delta
	var desired_velocity = get_input() * max_speed	
	velocity.x = desired_velocity.x
	velocity.z = desired_velocity.z
	velocity = move_and_slide(velocity, Vector3.UP, true)
	
	if Input.is_action_just_pressed("fire"):
		Gunshot.play()
		if Aim.is_colliding():
			var target = Aim.get_collider()
			if target.is_in_group("Enemy"):
				update_counter(1)
				target.health -= 1

func update_counter(s):
	Counter = get_node_or_null("HUD/Counter")
	if Counter != null:
		counter -= s
		Counter.text = "Enemies Remaining: " + str(counter)
		
remote func _set_position(pos):
	global_transform.origin = pos
