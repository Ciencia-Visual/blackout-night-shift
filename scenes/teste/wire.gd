extends Node2D

const ITERATIONS := 3

var control_points: Array[Vector2] = []
var mouse_position := Vector2.ZERO

func _process(_delta):
	mouse_position = get_global_mouse_position()
	queue_redraw()

func _unhandled_input(event):
	if event is InputEventMouseButton and event.pressed:
		
		match event.button_index:
			MOUSE_BUTTON_LEFT:
				control_points.append(get_global_mouse_position())
			
			MOUSE_BUTTON_RIGHT:
				control_points.clear()

func _draw():
	if control_points.is_empty():
		return

	# Copia os pontos de controle
	var render_points := control_points.duplicate()

	# Enquanto desenha, adiciona o mouse como último ponto
	render_points.append(mouse_position)

	# Suaviza
	for i in ITERATIONS:
		render_points = chaikin(render_points)

	# Desenha a curva
	for i in render_points.size() - 1:
		draw_line(
			to_local(render_points[i]),
			to_local(render_points[i + 1]),
			Color.WHITE,
			5.0,
			true
		)

	# Desenha os pontos de controle
	for point in control_points:
		draw_circle(
			to_local(point),
			5,
			Color.RED
		)

func chaikin(points: Array[Vector2]) -> Array[Vector2]:

	if points.size() < 2:
		return points

	var result: Array[Vector2] = []

	# Mantém o primeiro ponto
	result.append(points[0])

	for i in range(points.size() - 1):
		var a := points[i]
		var b := points[i + 1]

		var q := a.lerp(b, 0.25)
		var r := a.lerp(b, 0.75)

		result.append(q)
		result.append(r)

	# Mantém o último ponto
	result.append(points.back())

	return result
