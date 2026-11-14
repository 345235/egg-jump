extends Area2D
# Attach to your Area2D. In the Inspector, drag your win screen node into "Win Screen".

@export var win_screen: Node   # Node accepts Control, CanvasLayer, Sprite2D, etc.


func _ready() -> void:
	win_screen.visible = false
	body_entered.connect(_on_body_entered)


func _on_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:   # the player
		win_screen.visible = true
		get_tree().paused = true  # freeze the game a
