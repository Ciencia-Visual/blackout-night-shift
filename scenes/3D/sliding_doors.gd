extends Node3D

signal porta_fechada

@onready var anim = $AnimationPlayer
var aberta := false



func _ready():
	anim.animation_finished.connect(_on_animation_finished)
	
func _on_animation_finished(anim_name):
	if anim_name == "open" and not aberta:
		porta_fechada.emit()

func alternar_porta():
	if aberta:
		anim.play_backwards("open")
	else:
		anim.play("open")
	
	aberta = !aberta
	
	
	
	
func _input(event):
	if event.is_action_pressed("interact"):
		alternar_porta()
