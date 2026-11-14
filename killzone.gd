extends Area2D

func _on_body_entered(body: Area2D) -> void:
	if body.is_in_group("Player"):
		get_tree().change_scene_to_file("res://game_over.tscn")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
