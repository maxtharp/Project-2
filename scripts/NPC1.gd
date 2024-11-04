extends StaticBody2D

@onready var anim_player = $AnimationPlayer
@onready var label = $Label
@onready var talk_sound = $talk_sound
var inside : bool

func _ready() -> void:
	anim_player.play("idle")
	label.visible = false

func _process(delta: float) -> void:
	pass

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body == get_parent().get_node("player"):
		anim_player.play("selected")
		label.visible = true
		label.text = "press E to speak"
		inside = true


func _on_area_2d_body_exited(body: Node2D) -> void:
	anim_player.play("idle")
	label.visible = false
	inside = false
	
func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("E") and inside == true and get_parent().get_node("player").has_diamond == false:
		talk_sound.play()
		label.text = "PLEASE HELP.\nI LOST MY DIAMOND."
	if Input.is_action_just_pressed("E") and inside == true and get_parent().get_node("player").has_diamond == true:
		talk_sound.play()
		label.text = "THANK YOU!!"
		await get_tree().create_timer(1).timeout
		get_tree().change_scene_to_file("res://scenes/menu.tscn")
		
	
