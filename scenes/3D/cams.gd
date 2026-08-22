extends VBoxContainer

func _ready():
	configurar_botoes()

func configurar_botoes():
	for filho in get_children():
		if filho is Button:
			filho.pressed.connect(_on_botao_clicado.bind(filho))

func _alternar_cameras(indice_alvo: int):
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
		"Cam1":
			abrir_cam1()
		"Cam2":
			abrir_cam2()
		"Cam3":
			abrir_cam3()
		_:
			print("Ação padrão para o botão: ", texto)

func abrir_cam1():
	print("Câmera 1 Acessada")
	_alternar_cameras(0)
	

func abrir_cam2():
	print("Câmera 2 Acessada")
	_alternar_cameras(1)

func abrir_cam3():
	print("Câmera 3 Acessada")
	_alternar_cameras(2)
