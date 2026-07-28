extends Node
class_name PopupClose

@export var close_button: Button


func _ready():
	if close_button != null:
		close_button.pressed.connect(_on_close_button)

func _on_close_button() -> void:
	get_parent().hide()
