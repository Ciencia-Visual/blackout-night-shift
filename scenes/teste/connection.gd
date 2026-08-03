extends Node2D

var wire_scene = preload("res://scenes/teste/wire.tscn")

enum State {
	IDLE,
	DRAW_WIRE
}

var state := State.IDLE

var hovered_terminal: Terminal_ = null
var current_wire: Wire_ = null


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for terminal: Terminal_ in get_tree().get_nodes_in_group("terminals"):
		terminal.terminal_hovered.connect(_on_terminal_hovered)
		terminal.terminal_unhovered.connect(_on_terminal_unhovered)
		
	$"adjacency_list()".pressed.connect(print_adjacency_list)
	$"edge_list()".pressed.connect(print_edge_list)
	$"edge_dfs()".pressed.connect(print_edge_dfs)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_terminal_hovered(terminal: Terminal_) -> void:
	hovered_terminal = terminal


func _on_terminal_unhovered(terminal: Terminal_) -> void:
	if hovered_terminal == terminal:
		hovered_terminal = null


func _input(event: InputEvent) -> void:
	_handle_wire_input(event)
	
	if state == State.DRAW_WIRE:
		if event is InputEventMouseMotion:
			current_wire.update_preview(
				event.global_position
			)

func _handle_wire_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and !event.pressed:
			match state:
				State.IDLE:	
					if hovered_terminal:
						_start_wire()
				State.DRAW_WIRE:
					if hovered_terminal:
						_finish_wire()
					else:
						_add_wire_corner(event)

func _start_wire():
	current_wire = wire_scene.instantiate()
	$Wires.add_child(current_wire)
	
	current_wire.initialize(hovered_terminal)
	hovered_terminal.add_wire(current_wire)
	
	print("Criar fio")
	print("Começar fio em:".rpad(25), hovered_terminal)
	
	state = State.DRAW_WIRE
	

func _add_wire_corner(event: InputEventMouseButton):
	var point = event.global_position
	current_wire.add_corner(point)
	print("Fazer canto de fio em: ".rpad(25), point)


func _finish_wire():
	current_wire.finish(hovered_terminal)
	hovered_terminal.add_wire(current_wire)
	print("Terminar fio em: ".rpad(25), hovered_terminal)
	
	current_wire = null
	state = State.IDLE
	
	
func print_adjacency_list() -> void:

	print("\n=== ADJACENCY LIST ===")

	for terminal: Terminal_ in get_tree().get_nodes_in_group("terminals"):

		print("\n", terminal.name)

		for wire in terminal.connected_wires:

			var other := wire.get_other_terminal(terminal)

			print(
				"    ",
				wire.name,
				" -> ",
				other.name
			)

func print_edge_list() -> void:

	print("\n=== EDGE LIST ===")

	for wire: Wire_ in get_tree().get_nodes_in_group("wires"):

		print(
			wire.name,
			": ",
			wire.terminal_a.name,
			" <-> ",
			wire.terminal_b.name
		)

func print_edge_dfs():
	print("\n=== EDGE DFS ===")
	var start = $TerminalStart
	var visited_wires := {}

	_edge_dfs(start, visited_wires)

func _edge_dfs(terminal: Terminal_, visited_wires: Dictionary):

	print(terminal.name)

	for wire in terminal.connected_wires:

		if visited_wires.has(wire):
			continue

		visited_wires[wire] = true

		var other = wire.get_other_terminal(terminal)

		print(
			"    ",
			wire.name,
			" -> ",
			other.name
		)

		_edge_dfs(other, visited_wires)
