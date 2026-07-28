extends Node3D


@onready var anim = $AnimationPlayer
var aberta := false

func alternar_porta():
	if aberta:
		anim.play_backwards("open")
	else:
		anim.play("open")
	aberta = !aberta
func _input(event):
	if event.is_action_pressed("interact"):
		alternar_porta()
