extends StaticBody2D

@onready var anim_player = $AnimationPlayer
@onready var label = $Label
@onready var talk_sound = $talk_sound
var inside : bool
var dialogue_finished : bool
var portal = preload("res://scenes/portal.tscn")
var instanced_portal = portal.instantiate()

func _ready() -> void:
	instanced_portal.position = Vector2(2198, 208)
	anim_player.play("idle")
	label.visible = false

func _on_detection_area_body_entered(body: Node2D) -> void:
	if body == get_parent().get_node("player"):
		inside = true
		anim_player.play("selected")
		label.visible = true
		label.text = "\n\npress E to speak"

func _on_detection_area_body_exited(body: Node2D) -> void:
	anim_player.play("idle")
	label.visible = false
	inside = false
	
func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("E") and inside == true and get_parent().get_node("player").has_diamond == true:
		talk_sound.play()
		label.text = "\nTHANKS!!\nCOULD YOU RETURN IT TO HIM?"
	if Input.is_action_just_pressed("E") and inside == true and get_parent().get_node("player").has_diamond == false:
		talk_sound.play()
		label.text = "I'M SURE MY BROTHER ASKED YOU TO FIND HIS DIAMOND."
		await get_tree().create_timer(2).timeout
		talk_sound.play()
		label.text = "HE DROPPED IT ALL THE WAY OVER IN THE INDUSTRIAL DISTRICT."
		await get_tree().create_timer(2).timeout
		talk_sound.play()
		label.text = "I'LL OPEN A PORTAL, BUT BE WARNED. GODOT IS THERE..."
		await get_tree().create_timer(1).timeout
		get_parent().add_child(instanced_portal)
		dialogue_finished = true
	if dialogue_finished == true:
		label.text = "I'LL OPEN A PORTAL, BUT BE WARNED. GODOT IS THERE..."
