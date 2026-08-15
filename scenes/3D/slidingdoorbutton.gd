extends Node3D



@onready var area = $Area3D
@export var door: Node3D

func _ready():
	area.input_event.connect(_on_area_input_event)

func _on_area_input_event(camera, event, position, normal, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			print("botão clicado")
			door.alternar_porta()

func _on_area_3d_input_event(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			print("Botão clicado!")
