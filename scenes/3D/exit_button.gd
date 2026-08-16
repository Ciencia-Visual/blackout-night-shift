extends Node

@onready var area = $Area3D
@onready var interface_pc = $CanvasLayer

func _ready():
	area.input_event.connect(_on_area_input_event)

func fechar_interface():
	if interface_pc:
		interface_pc.visible = false
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE


func _on_area_input_event(camera, event, position, normal, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			print("PC ligado")
			fechar_interface()
