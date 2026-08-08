extends Panel


@onready var clock_label = $StatusContent/ClockLabel
@onready var game_time = $"../../GameTime"

func _process(_delta):
	clock_label.text = "%02d:%02d" % [game_time.hora, game_time.minuto]
