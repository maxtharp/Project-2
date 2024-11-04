extends StaticBody2D

@onready var pickupdiamond_sound = $pickupdiamond_sound

func _on_detection_area_body_entered(body: Node2D) -> void:
	self.get_parent().get_node("player").get_diamond()
	pickupdiamond_sound.play()
	visible = false
