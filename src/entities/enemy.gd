extends CharacterBody2D

const SPEED = 100.0
var target : Player = null

@export var hp: int = 100.0
@onready var cur_hp = hp
@export var knockback_resist: int = 0
@export var atk: int = 10
@export var def: int = 10
@export var speed: int = 150

var move = true

func _ready():
	# Find Player in parent ("World/Main" node)
	target = get_parent().get_node("Player")

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

func handle_hit():
	if cur_hp > 0:
		var tween = get_tree().create_tween().set_trans(Tween.TRANS_LINEAR)
		tween.tween_property($Sprite2D.get_material(), "shader_parameter/amount", 20, .06)
		tween.tween_property($Sprite2D.get_material(), "shader_parameter/amount", 0, .2)
		var shake = 1.5
		var shake_duration = 0.05
		var shake_count = 3
		var tween2 = get_tree().create_tween().set_trans(Tween.TRANS_LINEAR)
		for i in shake_count:
			tween2.tween_property($Sprite2D, "position", Vector2(randf_range(-shake, shake), randf_range(-shake, shake)), shake_duration)
			tween2.tween_property($Sprite2D, "position", Vector2(0,0), .01)
		cur_hp -= 20 # Replace with real damage formula
	if cur_hp <= 0:
		die()

func die():
	$Sprite2D.texture = "res://assets/particles/death_test.png"
	move = false
	$Hurtbox.monitoring = false
	$Hurtbox.monitorable = false
	$AnimationPlayer.play("death")
	await $AnimationPlayer.animation_finished
	queue_free()
