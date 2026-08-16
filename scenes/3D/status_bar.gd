extends Panel


@export var time_label: Label
@export var game_time: Node

func _process(_delta):
	time_label.text = "%02d:%02d" % [game_time.hora, game_time.minuto]
