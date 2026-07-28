extends Panel
@onready var current_bar = $MarginContainer/VBoxContainer/CurrentBar
@onready var current_value = $MarginContainer/VBoxContainer/CurrentValue
@onready var religar_button = $MarginContainer/VBoxContainer/ReligarButton
var corrente_residual := 400.0
var protocolo_ativo := false



func _ready():
	hide()
	religar_button.disabled = true
	
	
func _process(delta):
	if protocolo_ativo:
		corrente_residual -= 20 * delta
		corrente_residual = max(corrente_residual, 0)
		current_bar.value = corrente_residual
		current_value.text = str(int(corrente_residual)) + " A"
		if corrente_residual <= 200:
			religar_button.disabled = false
		

func iniciar_protocolo():
	show()
	corrente_residual = 400
	protocolo_ativo = true
	current_bar.value = corrente_residual
	current_value.text = str(int(corrente_residual)) + " A"
	religar_button.disabled = true


func _on_religar_button_pressed():
	protocolo_ativo= false
	hide()
