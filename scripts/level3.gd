extends Node2D

@onready var player = $player
@onready var portal_noise = $portal_noise

func _ready() -> void:
	portal_noise.play()
	player.has_diamond = true

func _on_area_2d_body_entered(body: Node2D) -> void:
	player.position = Vector2(2192,212)
