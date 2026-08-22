extends VBoxContainer

func _ready():
	configurar_botoes()

func configurar_botoes():
	for filho in get_children():
		if filho is Button:
			filho.pressed.connect(_on_botao_clicado.bind(filho))

func _alternar_interface(indice_alvo: int):
	var botoes: Array[Button] = []
	
	for filho in get_children():
		if filho is Button:
			botoes.append(filho)
			
	for i in botoes.size():
		var botao = botoes[i]
		var deve_ficar_visivel = (i == indice_alvo)
		
		for subfilho in botao.get_children():
			if subfilho is Control: 
				subfilho.visible = deve_ficar_visivel

func _on_botao_clicado(botao_pressionado: Button):
	var nome = botao_pressionado.name
	var texto = botao_pressionado.text
	
	print("Botão clicado: ", nome, " | Texto: ", texto)
	
	match nome:
		"Energybutton":
			abrir_energia()
		"Camerabutton":
			abrir_camera()
		"Antenabutton":
			abrir_antena()
		"ExitButton":
			desligar_pc()
		_:
			print("Ação padrão para o botão: ", texto)

func abrir_energia():
	print("Executando: Abrir Painel de Energia")
	_alternar_interface(0)

func abrir_camera():
	print("Executando: Abrir Cameras")
	_alternar_interface(1)

func abrir_antena():
	print("Executando: Abrir Antena")
	_alternar_interface(2)

func desligar_pc():
	$"..".visible = false
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
