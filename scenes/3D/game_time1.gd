extends Node


var hora := 22
var minuto := 0
var energia := 100.0


@export var consumo_por_minuto := 0.2
@onready var energy_label = $"../HUD/StatusBar/StatusContent/EnergyLabel"
@export var segundos_por_minuto := 1.0
@onready var time_label = $"../HUD/StatusBar/StatusContent/ClockLabel"
var tempo := 0.0


func _process(delta):
	tempo += delta
	if tempo >= segundos_por_minuto:
		tempo = 0
		minuto += 1
		energia -= consumo_por_minuto
		energia = max(energia, 0.0)
	if minuto >= 60:
		minuto = 0
		hora += 1
		if hora >=24:
			hora = 0
	if hora == 0 and minuto == 30:
		get_tree().change_scene_to_file("res://scenes/night_complete.tscn")
	time_label.text = "%02d:%02d" % [hora, minuto]
	energy_label.text = "ENERGIA: %d%%" % int(energia)
			
