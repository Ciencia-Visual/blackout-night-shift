extends Control
class_name Puzzle

@export var grid_container: GridContainer
@export var work_space: BoxContainer
@export var wires: Node2D

const PUZZLES := {
	"puzzle_1": preload("res://resources/circuit_puzzles/puzzles/puzzle_1.tres")
}
const WIRE_SCENE = preload("res://scenes/circuit_puzzle/components/wire.tscn")

enum State {
	IDLE,
	DRAW_WIRE
}
var state := State.IDLE

var hovered_terminal: Terminal = null
var current_wire: Wire = null
var next_wire_id := 1


func _ready() -> void:
	# Carregar level 1 - funcionalidade desenvolvimento 
	load_inventory(PUZZLES.puzzle_1)
	
	# Conectar eventos de terminais de componentes
	# inseridos manualmente no puzzle
	for terminal: Terminal in get_tree().get_nodes_in_group("terminals"):
		terminal.terminal_hovered.connect(_on_terminal_hovered)
		terminal.terminal_unhovered.connect(_on_terminal_unhovered)

	# Botões de testes
	$"VBoxContainer/adjacency_list()".pressed.connect(print_adjacency_list)
	$"VBoxContainer/edge_list()".pressed.connect(print_edge_list)
	$"VBoxContainer/edge_dfs()".pressed.connect(print_edge_dfs)
	$"VBoxContainer/Simular".pressed.connect(simular_circuito)

	# Inicializar um Led conectado
	var led = $HBoxContainer/WorkSpace/Led
	var energy_source = $HBoxContainer/WorkSpace/EnergySourceBanana
	
	#print(led.terminals["anodo"])
	#_start_wire(led.terminals["anodo"])
	#_finish_wire(energy_source.terminals["positivo"])
	#_start_wire(led.terminals["catodo"])
	#_finish_wire(energy_source.terminals["negativo"])
	

## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(_delta: float) -> void:
	#pass


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


# Click (down) no item do iventario
func _on_slot_down(slot):
	# gerar uma cena do item
	var component = slot.get_meta("component_data")
	var component_scene: Component = component.scene.instantiate()
	# Adicionar no work_space
	work_space.add_child(component_scene)
	
	# Conectar os terminais às funções 
	for terminal: Terminal in component_scene.terminals.values():
		terminal.terminal_hovered.connect(_on_terminal_hovered)
		terminal.terminal_unhovered.connect(_on_terminal_unhovered)
	
	# Seguir o mouse
	component_scene.start_drag()


func _on_terminal_hovered(terminal: Terminal) -> void:
	hovered_terminal = terminal


func _on_terminal_unhovered(terminal: Terminal) -> void:
	if hovered_terminal == terminal:
		hovered_terminal = null


func _input(event: InputEvent) -> void:
	_handle_wire_input(event)
	

func _handle_wire_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and !event.pressed:
			match state:
				State.IDLE:	
					if hovered_terminal:
						_start_wire(hovered_terminal)
				State.DRAW_WIRE:
					if hovered_terminal:
						_finish_wire(hovered_terminal)
					else:
						_add_wire_corner(event)
						
	if state == State.DRAW_WIRE:
		if event is InputEventMouseMotion:
			current_wire.update_preview(event.global_position)


func _start_wire(terminal: Terminal):
	current_wire = WIRE_SCENE.instantiate()
	
	#current_wire.id = next_wire_id
	
	wires.add_child(current_wire)
	current_wire.name = "Wire_%02d" % next_wire_id
	print(current_wire.name)
	
	current_wire.initialize(terminal)
	
	print("Criar fio")
	print("Começar fio em:".rpad(25), terminal)
	
	state = State.DRAW_WIRE
	

func _add_wire_corner(event: InputEventMouseButton):
	var point = event.global_position
	current_wire.add_corner(point)
	print("Fazer canto de fio em: ".rpad(25), point)


func _finish_wire(terminal: Terminal):
	current_wire.finish(terminal)
	print("Terminar fio em: ".rpad(25), terminal)
	
	current_wire = null
	state = State.IDLE
	
	
func print_adjacency_list() -> void:
	print("\n=== ADJACENCY LIST ===")
	for terminal: Terminal in get_tree().get_nodes_in_group("terminals"):
		print("\n", terminal.name)
		for wire in terminal.connected_wires:
			var other := wire.get_other_terminal(terminal)
			print("\t", wire.name," -> ",other.name)

func print_edge_list() -> void:
	print("\n=== EDGE LIST ===")
	for wire: Wire in get_tree().get_nodes_in_group("wire"):
		print(wire.name, ": ", wire.terminal_a.name, " <-> ", wire.terminal_b.name)

func print_edge_dfs():
	print("\n=== EDGE DFS ===")
	var start = $HBoxContainer/WorkSpace/EnergySourceBanana/Positivo
	var visited_wires := {}

	_edge_dfs(start, visited_wires)

func _edge_dfs(terminal: Terminal, visited_wires: Dictionary):
	print(terminal.name)
	for wire in terminal.connected_wires:
		if visited_wires.has(wire):
			continue
		visited_wires[wire] = true
		var other = wire.get_other_terminal(terminal)
		print("\t", wire.name, " -> ", other.name)

		_edge_dfs(other, visited_wires)


func simular_circuito():
	# Iniciar procurando elementos de fonte de energia
	for energy_source in get_tree().get_nodes_in_group("energy_source"):
		print(energy_source)
		print(energy_source.terminals['positivo'])
		energy_source.terminals['positivo'] 
		
		
	#for energy_source in work_space.get_groups()
	pass
