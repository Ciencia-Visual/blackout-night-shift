extends Node3D


signal robo_bloqueado
@onready var robot_visual = $RobotVisual
@onready var game_time = $"../GameTime"

var ameaca := 0.0
var verificando := 0.0
var robo_apareceu := false

@export var intervalo_verificacao := 5.0
@export var ameaca_inicial := 0.02
@export var ameaca_maxima := 0.25

func _ready():
	robot_visual.visible = false



func _process(delta):
	if robo_apareceu:
		return

	verificando += delta

	if verificando >= intervalo_verificacao:
		verificando = 0.0
		verificar_ameaca()


func verificar_ameaca():
	var minutos_jogo = (game_time.hora - 22) * 60 + game_time.minuto
	
	if minutos_jogo < 0:
		minutos_jogo += 1440
	
	ameaca = ameaca_inicial + (minutos_jogo / 150.0) * ameaca_maxima
	
	ameaca = clamp(ameaca, ameaca_inicial, ameaca_maxima)

	if randf() < ameaca:
		aparecer()


func aparecer():
	robo_apareceu = true
	robot_visual.visible = true
	print("O ROBÔ APARECEU!")


func fechar_porta():
	robo_apareceu = false
	robot_visual.visible = false
	print("A porta foi fechada!")


func _on_sliding_doors_porta_fechada():
	fechar_porta()
