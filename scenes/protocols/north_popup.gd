extends Panel
@export var option_a: CheckBox
@export var option_b : CheckBox
@export var confirm_button = Button
@export var result_label : Label


signal protocolo_concluido
func iniciar_protocolo():
	show()


func _on_confirm_button_pressed():
	if option_a.button_pressed:
		result_label.text = "✅ PROTOCOLO EXECUTADO COM SUCESSO"
		await get_tree().create_timer(1.2).timeout
		emit_signal("protocolo_concluido")
		hide()
		option_a.button_pressed = false
		option_b.button_pressed = false
		result_label.text = ""
	elif option_b.button_pressed:
		result_label.text = "❌ PROCEDIMENTO INVÁLIDO"
	else:
		result_label.text = "⚠️ Selecione uma opção."
