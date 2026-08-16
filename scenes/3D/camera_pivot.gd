extends Node3D

const MIN_PITCH := -80.0
const MAX_PITCH := 80.0

const MIN_YAW := -90.0
const MAX_YAW := 90.0

const SENSITIVITY := 0.15
const SMOOTH_SPEED := 12.0

var target_pitch := 0.0
var target_yaw := 0.0

@export var camera: Camera3D
@export var interaction_ray: RayCast3D


func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE


func _input(event):

	# ESC libera o mouse
	if event is InputEventKey:
		if event.keycode == KEY_ESCAPE and event.pressed:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
			return

	# Clique captura o mouse
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			if Input.mouse_mode != Input.MOUSE_MODE_CAPTURED:
				Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
				return
				
			interagir_com_objeto()

	# Movimento da câmera
	if event is InputEventMouseMotion:
		if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:

			target_yaw -= event.relative.x * SENSITIVITY
			target_pitch -= event.relative.y * SENSITIVITY

			target_yaw = clamp(target_yaw, MIN_YAW, MAX_YAW)
			target_pitch = clamp(target_pitch, MIN_PITCH, MAX_PITCH)


func _process(delta):

	rotation_degrees.y = lerp(
		rotation_degrees.y,
		target_yaw,
		delta * SMOOTH_SPEED
	)

	rotation_degrees.x = lerp(
		rotation_degrees.x,
		target_pitch,
		delta * SMOOTH_SPEED
	)


func interagir_com_objeto():
	if not interaction_ray.is_colliding():
		return

	var objeto = interaction_ray.get_collider()

	print("Objeto atingido: ", objeto)

	if objeto.get_parent().has_method("interagir"):
		print("Tem função interagir")
		objeto.get_parent().interagir()
