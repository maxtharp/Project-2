extends CharacterBody2D

const SPEED = 220.0
const JUMP_VELOCITY = -350.0
const FRICTION = 10

enum {
	MOVE, ATTACK
}

var state = MOVE
var jumping = false
var attacking = false
var facing = 1
var has_diamond = false
@onready var jump_sound = $jump_sound
@onready var swing_sound = $swing_sound
@onready var anim_player = $AnimationPlayer
@onready var sprite = $Sprite2D
@onready var anim_tree = $AnimationTree
@export var particle_resource : PackedScene

func _physics_process(delta: float) -> void:
	var dir := Input.get_axis("left", "right")
	if not is_on_floor():
		anim_tree['parameters/conditions/idle'] = false
		anim_tree['parameters/conditions/walk'] = false
		anim_tree['parameters/conditions/jump'] = true
		velocity += get_gravity() * delta
	else:
		jumping = false
		
	match state:
		MOVE:
			move_state(dir)
		ATTACK:
			attack_state()
			
func move_state(direction):
	if jumping == false:
		anim_tree['parameters/conditions/jump'] = false
	
	if direction:
		velocity.x = move_toward(velocity.x, direction * SPEED, FRICTION)
		flip(direction)
		
		if not jumping:
			if velocity.length() > .01:
				anim_tree['parameters/conditions/idle'] = false
				anim_tree['parameters/conditions/walk'] = true
	else:
		velocity.x = move_toward(velocity.x, 0, FRICTION)
		if velocity.x == 0 and not jumping:
			anim_tree['parameters/conditions/walk'] = false
			anim_tree['parameters/conditions/idle'] = true

	if Input.is_action_just_pressed("up") and is_on_floor():
		jumping = true
		jump_sound.play()
		velocity.y = JUMP_VELOCITY
		
	if attacking == false:
		if Input.is_action_just_pressed("attack"):
			attacking = true
			swing_sound.play()
			state = ATTACK

	move_and_slide()
		
func attack_state():
	if jumping == true and attacking == true:
		anim_tree['parameters/conditions/jumpattack'] = true
		await anim_tree.animation_finished
		attacking = false
		state = MOVE
		anim_tree['parameters/conditions/jumpattack'] = false
	else:
		anim_tree['parameters/conditions/attack'] = true
		await anim_tree.animation_finished
		attacking = false
		state = MOVE
		anim_tree['parameters/conditions/attack'] = false

func get_hit():
	var parent = self.get_parent()
	var death_effect : GPUParticles2D = particle_resource.instantiate()
	
	death_effect.position = position
	parent.add_child(death_effect)
	death_effect.emitting = true
	self.visible = false
	set_physics_process(false)
	await get_tree().create_timer(1).timeout
	self.visible = true
	set_physics_process(true)
	self.position = Vector2(191,214)
	
func get_diamond():
	has_diamond = true
	
func flip(direction):
	if direction < 0 and facing == 1:
		self.scale.x = -1
		facing = -1
	if direction > 0 and facing == -1:
		self.scale.x = -1
		facing = 1
	
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body != self:
		body.enemy_get_hit()
	
	
