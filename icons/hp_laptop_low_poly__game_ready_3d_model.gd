extends Node3D

@onready var area = $Area3D
@onready var interface_pc = $ComputerUI


func abrir_interface():
	print("PC ligado")
	if interface_pc:
		interface_pc.visible = true
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE


func interagir():
	abrir_interface()
