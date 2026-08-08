class_name Led extends Component

@onready var sprite = $Sprite2D as Sprite2D
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super._ready()
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	super._process(_delta)
	
