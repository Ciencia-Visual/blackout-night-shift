extends Node3D

@export var door: Node3D


func interagir():
	print("Botão clicado!")
	door.alternar_porta()
