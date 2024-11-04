extends CharacterBody2D

var speed = -60.0
@onready var ground_check = $RayCast2D
@export var particle_resource : PackedScene

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	if !ground_check.is_colliding() and is_on_floor():
		flip()
	velocity.x = speed
	move_and_slide()
	
func flip():
	scale.x = scale.x * -1
	speed = speed * -1

func enemy_get_hit():
	var parent = self.get_parent()
	var death_effect : GPUParticles2D = particle_resource.instantiate()
	
	death_effect.position = position
	parent.add_child(death_effect)
	death_effect.emitting = true
	queue_free()

func _on_hitbox_body_entered(body: Node2D) -> void:
	if body == get_parent().get_node("player"):
		body.get_hit()
	
