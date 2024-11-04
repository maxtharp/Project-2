extends StaticBody2D

var inside : bool
@onready var sprite =  $AnimatedSprite2D
@onready var label = $Label

func _ready() -> void:
	sprite.play("portal_ready")
	label.visible = false

func _on_detection_area_body_entered(body: Node2D) -> void:
	if body == get_parent().get_node("player"):
		label.visible = true
		inside = true

func _on_detection_area_body_exited(body: Node2D) -> void:
	label.visible = false
	inside = false
	
func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("E") and inside == true:
		get_tree().change_scene_to_file("res://scenes/Level2.tscn")
