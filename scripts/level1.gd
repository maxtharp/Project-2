extends Node2D

@onready var player = $player

func _on_area_2d_body_entered(body: Node2D) -> void:
	player.position = Vector2(191,214)
	