extends Node2D

@onready var player = $player
@onready var portal_noise = $portal_noise
var portal = preload("res://scenes/portal2.tscn")
var instanced_portal = portal.instantiate()

func _ready() -> void:
	portal_noise.play()
	instanced_portal.position = Vector2(172, 206)
	add_child(instanced_portal)
	instanced_portal.process_mode = Node.PROCESS_MODE_DISABLED
	instanced_portal.visible = false

func _on_area_2d_body_entered(body: Node2D) -> void:
	player.position = Vector2(191,214)
	
func _physics_process(delta: float) -> void:
	if player.has_diamond:
		instanced_portal.process_mode = Node.PROCESS_MODE_ALWAYS
		instanced_portal.visible = true
	
