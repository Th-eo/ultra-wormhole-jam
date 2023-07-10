class_name Enemy
extends CharacterBody2D

enum EnemyState {
	IDLE,
	CHASE,
	ATTACK,
}

var current_state = EnemyState.IDLE

var player
@export var speed = 100
@export var attack_range = 100
var is_attacking = false

var attack_timer = 0.0
@export var attack_delay = 1.0

# Stats
@export var max_hp = 100
var cur_hp = max_hp
@export var defense = 1.0

func _ready():
	player = get_parent().get_node("Player")
	$TextureProgressBar.visible = false

# Knockback variables
var knockback = false
var knockback_strength = 100.0
var knockback_duration = 0.5
var knockback_timer = 0.0
var knockback_direction = Vector2.ZERO
@export var knockback_resistance = 1.0

func _process(delta):
	var attack_pos = getAttackPosition()
	var direction = attack_pos - global_position
	var distance_to_player = direction.length()

	match current_state:
		EnemyState.IDLE:
			if knockback:
				move_and_collide(knockback_direction * knockback_strength * delta)
				knockback_timer += delta
				if knockback_timer >= knockback_duration:
					knockback = false
					knockback_timer = 0.0
			else:
				if distance_to_player <= attack_range:
					current_state = EnemyState.ATTACK
				else:
					direction = direction.normalized()
					move_and_collide(direction * speed * delta)

		EnemyState.CHASE:
			if knockback:
				move_and_collide(knockback_direction * knockback_strength * delta)
				knockback_timer += delta
				if knockback_timer >= knockback_duration:
					knockback = false
					knockback_timer = 0.0
			else:
				if distance_to_player > attack_range:
					current_state = EnemyState.IDLE
				else:
					attack_timer -= delta
					if attack_timer <= 0:
						shoot()
						attack_timer = attack_delay

		EnemyState.ATTACK:
			if knockback:
				move_and_collide(knockback_direction * knockback_strength * delta)
				knockback_timer += delta
				if knockback_timer >= knockback_duration:
					knockback = false
					knockback_timer = 0.0
			else:
				if distance_to_player > attack_range:
					current_state = EnemyState.CHASE
				else:
					attack_timer -= delta
					if attack_timer <= 0:
						shoot()
						attack_timer = attack_delay
	if velocity.x < 0: # Flip based on direction
		$Sprite2D.flip_h = false
	if velocity.x > 0:
		$Sprite2D.flip_h = true
	if velocity != Vector2.ZERO:
		$AnimationPlayer.play("walk") # TODO
	elif cur_hp > 0:
		$AnimationPlayer.play("idle") # TODO
	update_state_label()

func update_state_label():
	match current_state:
		EnemyState.IDLE:
			$Label.set_text("IDLE")
		EnemyState.CHASE:
			$Label.set_text("CHASE")
		EnemyState.ATTACK:
			$Label.set_text("ATTACK")

func handle_hit(damage):
	var tween = get_tree().create_tween().set_trans(Tween.TRANS_LINEAR)
	var tween2 = get_tree().create_tween().set_trans(Tween.TRANS_LINEAR)
	if cur_hp > 0:
		tween.tween_property($Sprite2D.get_material(), "shader_parameter/amount", 20, .06)
		tween.tween_property($Sprite2D.get_material(), "shader_parameter/amount", 0, .2)
		var shake = 1.5
		var shake_duration = 0.05
		var shake_count = 3
		for i in shake_count:
			tween2.tween_property($Sprite2D, "position", Vector2(randf_range(-shake, shake), randf_range(-shake, shake)), shake_duration)
			tween2.tween_property($Sprite2D, "position", Vector2(0,0), .01)
		cur_hp -= damage # Replace with real damage formula
	update_hp()
	if cur_hp <= 0:
		tween.stop()
		tween2.stop()
		die()

func set_knockback(do, strength, duration, direction):
	knockback = do
	knockback_strength = strength
	knockback_duration = duration
	knockback_direction = direction

func getAttackPosition():
	return player.global_position

func shoot():
	var projectile = preload("res://src/entities/bubble.tscn")
	var tween = get_tree().create_tween().set_trans(Tween.TRANS_BOUNCE)
	tween.tween_property($Sprite2D, "scale", Vector2(1.2, 1.2), 0.05)
	tween.tween_property($Sprite2D, "scale", Vector2(1, 1), 0.05)
	var instance = projectile.instantiate()
	instance.global_position = global_position
	instance.target_position = player.global_position
	instance.projectile_owner = self
	get_parent().add_child(instance)

func update_hp():
	var progress = float(cur_hp) / max_hp * 100
	$TextureProgressBar.setProgress(progress)

var death_particles = preload("res://src/entities/deathanimparticles.tscn")

func die():
	$Hurtbox.set_deferred("monitoring" ,false)
	$Hurtbox.set_deferred("monitorable" ,false)
	$AnimationPlayer.play("death")
	await $AnimationPlayer.animation_finished
	queue_free()
	var death = death_particles.instantiate()
	death.set_scale(scale)
	death.global_position = global_position+Vector2(0,0) # Vector to fix centering of the particles, might need testing so leaving as 0,0
	get_parent().add_child(death)
