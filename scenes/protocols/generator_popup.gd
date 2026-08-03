extends Panel


signal gerador_reparado
signal peca_errada


@export var slot_label : Label
@export var wire_button : Button
@export var switch_button : Button
@export var resistor_button : Button
@export var question: Control
@export var puzzle: Control


func iniciar_protocolo():
	question.show()
	puzzle.hide()
	show()
	

func _on_wire_button_pressed():
	slot_label.text = "══"
	await get_tree().create_timer(1.0).timeout
	question.hide()
	puzzle.show()
	emit_signal("gerador_reparado")
	#hide()


func _on_switch_button_pressed():
	slot_label.text = "X"
	await get_tree().create_timer(1.0).timeout
	slot_label.text = "□"
	emit_signal("peca_errada")


func _on_resistor_button_pressed():
	slot_label.text = "R"
	await get_tree().create_timer(1.0).timeout
	slot_label.text = "□"
	emit_signal("peca_errada")
