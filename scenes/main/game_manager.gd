extends Node

# Esta variável guarda a hora atual do jogo (começa à meia-noite)
var hora_atual: int = 0

# Esta função é executada automaticamente sempre que o Timer chega a zero
func _on_timer_timeout():
	hora_atual += 1
	# Aqui está o truque: 
	# Estamos a procurar o nó chamado 'RelogioLabel' que criámos na HUD
	# e a mudar o texto dele para mostrar a hora atual.
	var texto_label = get_tree().root.find_child("RelogioLabel", true, false)
	if texto_label:
		texto_label.text = str(hora_atual) + ":00"
	
	if hora_atual >= 6:
		print("Sobreviveste!")
		$Timer.stop()
