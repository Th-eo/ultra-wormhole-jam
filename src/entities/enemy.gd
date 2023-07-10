extends CharacterBody2D

const SPEED = 100.0
var target : Player = null
var death_particles = preload("res://src/entities/deathanimparticles.tscn")

@export var hp: float = 100
@onready var cur_hp: float = hp
@export var knockback_resist: int = 0
@export var atk: int = 10
@export var def: int = 10
@export var speed: int = 150

var move = true

func _ready():
	# Find Player in parent ("World/Main" node)
	target = get_parent().get_node("Player")
	$TextureProgressBar.visible = false

func _physics_process(delta):
	if target and move and cur_hp > 0:
		velocity = global_position.direction_to(target.global_position)
		move_and_collide(velocity * SPEED * delta)
	if velocity.x < 0: # Flip based on direction
		$Sprite2D.flip_h = false
	if velocity.x > 0:
		$Sprite2D.flip_h = true
	if velocity != Vector2.ZERO and move:
		$AnimationPlayer.play("walk") # TODO
	elif cur_hp > 0:
		$AnimationPlayer.play("idle") # TODO

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
	if cur_hp < hp: # Show HP bar if the enemy is damaged
		show_hp()
	update_hp()
	if cur_hp <= 0:
		tween.stop()
		tween2.stop()
		die()

func show_hp():
	pass

func update_hp():
	var progress = cur_hp / hp * 100
	$TextureProgressBar.setProgress(progress)

# Files should be preloaded so there's no minilag
# Alternatively you can use load(path to the file) to load them immediately
# But not just the string
var death_sprite = preload("res://assets/particles/death_test.png")

func die():
	$Sprite2D.texture = death_sprite
	move = false
	$Hurtbox.set_deferred("monitoring" ,false)
	$Hurtbox.set_deferred("monitorable" ,false)
	$AnimationPlayer.play("death")
	await $AnimationPlayer.animation_finished
	queue_free()
	var death = death_particles.instantiate()
	death.set_scale(scale)
	death.global_position = global_position
	get_parent().add_child(death)
