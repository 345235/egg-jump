extends Node2D


@export var platform_scene: PackedScene
@export var player: CharacterBody2D
@export var camera: Camera2D

const VIEW_WIDTH := 480.0
const VIEW_HEIGHT := 800.0
const MIN_GAP := 80.0
const MAX_GAP := 170.0        # must stay below max jump height (~200 px)
const DIFFICULTY_DISTANCE := 20000.0   # pixels until max difficulty

var top_y := 0.0              # y of the highest platform so far (smaller = higher)
var best_height := 0.0


func _ready() -> void:
	randomize()
	camera.position = Vector2(VIEW_WIDTH / 2.0, player.position.y)

	# Starting platform right under the player
	top_y = player.position.y + 40.0
	_add_platform(Vector2(VIEW_WIDTH / 2.0, top_y))
	_spawn_until(camera.position.y - VIEW_HEIGHT * 1.5)


func _process(_delta: float) -> void:
	# Camera only moves up, never down
	if player.position.y < camera.position.y:
		camera.position.y = player.position.y

	_spawn_until(camera.position.y - VIEW_HEIGHT * 1.5)
	_cleanup()

	best_height = max(best_height, -player.position.y)

	# Game over: player fell below the screen
	if player.position.y > camera.position.y + VIEW_HEIGHT / 2.0 + 100.0:
		get_tree().reload_current_scene()


func _spawn_until(target_y: float) -> void:
	while top_y > target_y:
		var difficulty: float = clamp(-top_y / DIFFICULTY_DISTANCE, 0.0, 1.0)
		var gap: float = lerp(MIN_GAP, MAX_GAP, difficulty) + randf_range(-10.0, 10.0)
		gap = clamp(gap, MIN_GAP, MAX_GAP)
		top_y -= gap
		_add_platform(Vector2(randf_range(40.0, VIEW_WIDTH - 40.0), top_y))


func _add_platform(pos: Vector2) -> void:
	var p := platform_scene.instantiate()
	p.position = pos
	add_child(p)


func _cleanup() -> void:
	var limit := camera.position.y + VIEW_HEIGHT / 2.0 + 150.0
	for child in get_children():
		if child.position.y > limit:
			child.queue_free()
