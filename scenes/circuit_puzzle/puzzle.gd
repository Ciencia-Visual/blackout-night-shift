extends Control
class_name Puzzle

@export var grid_container: GridContainer
@export var work_space: BoxContainer

const PUZZLES := {
	"puzzle_1": preload("res://resources/circuit_puzzles/puzzles/puzzle_1.tres")
}

var dragging_component: Dragging = null


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	load_inventory(PUZZLES.puzzle_1)
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
	

# Loading Inventory
func load_inventory(puzzle: PuzzleData):
	var slot_position := 0
	var inventory_slots = grid_container.get_children()
	for component_data in puzzle.inventory_components:
		if component_data != null:
			var slot = inventory_slots[slot_position]
			slot.set_meta("component_data", component_data)
			slot.find_child("Item").texture = component_data.texture
			slot.find_child("Label").text = component_data.name
			slot_position += 1
			slot.button_down.connect(_on_slot_down.bind(slot))
	
			
# Click no item do iventario
func _on_slot_down(slot):
	# gerar uma cena do item
	var component = slot.get_meta("component_data")
	var scene_component: Node2D = component.scene.instantiate()
	work_space.add_child(scene_component)
	scene_component.position = scene_component.find_child("Dragging").get_mouse_position()
	
	# Seguir o mouse
	dragging_component = scene_component.find_child("Dragging")
	dragging_component.start_drag()
	

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and not event.pressed:
			if dragging_component != null:
				dragging_component.stop_drag()
				dragging_component = null


func _on_terminais_mark_terminal() -> void:
	pass # Replace with function body.
