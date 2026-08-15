extends Control



var main = preload("res://scenes/3D/control_room.tscn")

func _on_starter_button_pressed() -> void:
	$ClickSound.play()
	await get_tree().create_timer(0.3).timeout
	$AnimationPlayer.play("FadeOut")
	await $AnimationPlayer.animation_finished
	get_tree().change_scene_to_packed(main)
