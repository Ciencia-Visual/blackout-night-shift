extends Control
@onready var report_label = $ColorRect/CenterContainer/VBoxContainer/ReportLabel
var report_text = """
RELATÓRIO DO OPERADOR
Energia restante:
84%
Protocolos concluídos:
2/2
Tempo de serviço:
1h 00min
"""
@onready var nextstep_button = $Nextstep







# Called when the node enters the scene tree for the first time.
func _ready():
	nextstep_button.hide()
	report_label.text = ""
	await type_text()
	nextstep_button.show()






func type_text():
	for letra in report_text:
		report_label.text += letra
		await get_tree().create_timer(0.03).timeout


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
