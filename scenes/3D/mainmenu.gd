extends VBoxContainer

func _ready():
	configurar_botoes()

func configurar_botoes():
	for filho in get_children():
		if filho is Button:
			filho.pressed.connect(func(): _on_botao_clicado(filho))

func _on_botao_clicado(botao_pressionado: Button):
	var nome = botao_pressionado.name
	var texto = botao_pressionado.text
	
	print("Botão clicado: ", nome, " | Texto: ", texto)
	
	match nome:
		"Camerabutton":
			abrir_camera()
		"Antenabutton":
			abrir_antena()
		"Energybutton":
			abrir_energia()
		"ExitButton":
			desligar_pc()
		_:
			print("Ação padrão para o botão: ", texto)

func abrir_camera():
	print("Executando: Abrir Cameras")

func abrir_antena():
	print("Executando: Abrir Antena")

func abrir_energia():
	print("Executando: Abrir Painel de Energia")

func desligar_pc():
	$"..".visible = false
