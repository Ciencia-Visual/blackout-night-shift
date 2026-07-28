extends Node3D


const MIN_YAW := -55.0
const MAX_YAW := 40.0
const SENSITIVITY := 0.15
var target_yaw := 0.0

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
func _input(event):
	if event is InputEventMouseMotion:
		target_yaw -= event.relative.x * SENSITIVITY
		target_yaw = clamp(target_yaw, MIN_YAW, MAX_YAW)
		
func _process(delta):
	rotation_degrees.y = lerp(rotation_degrees.y, target_yaw, delta * 8.0)
