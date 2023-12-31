class_name Player
extends CharacterBody2D

#Stats
@export var max_hp = 100
@export var cur_hp = max_hp
var defense = 1.0
const SPEED = 300.0
var can_move = true # Variable to lock player input?

# Knockback variables
var knockback = false
var knockback_strength = 100.0
var knockback_duration = 0.5
var knockback_timer = 0.0
var knockback_direction = Vector2.ZERO
@export var knockback_resistance = 1.0

var fire_rate = 0.2
@onready var fire_timer = $Timer
var can_shoot = true

signal hp_signal

func _ready():
	$AnimationPlayer.play("idle") # TODO
	fire_timer.one_shot = false
	fire_timer.wait_time = fire_rate

func _physics_process(_delta):
	if can_move == true: move()
	move_and_slide()
	if velocity.x < 0: # Flip based on direction
		$Sprite2D.flip_h = true
	if velocity.x > 0:
		$Sprite2D.flip_h = false
	if velocity != Vector2.ZERO:
		$AnimationPlayer.play("walk") # TODO
	else:
		$AnimationPlayer.play("idle")
	if Input.is_action_pressed("fire") and can_shoot:
		fire()
		wiggle() # Scale wiggle, just for input feedback
		# Also the word wiggle is fun
		can_shoot = false
		fire_timer.start()
	if Input.is_action_pressed("special"):
		special()
		

func move():
	var direction = Vector2(Input.get_axis("left", "right"),Input.get_axis("up", "down"))
	direction = direction.normalized()
	if direction.x:
		velocity.x = direction.x * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	if direction.y:
		velocity.y = direction.y * SPEED
	else:
		velocity.y = move_toward(velocity.y, 0, SPEED)

func fire():
	var projectile = preload("res://src/entities/bubble.tscn")
	var tween = get_tree().create_tween().set_trans(Tween.TRANS_BOUNCE)
	tween.tween_property($Sprite2D, "scale", Vector2(1.2, 1.2), 0.05)
	tween.tween_property($Sprite2D, "scale", Vector2(1, 1), 0.05)
	var instance = projectile.instantiate()
	instance.transform = $ProjectileOrigin.transform
	instance.global_position = $ProjectileOrigin.global_position
	instance.target_position = get_global_mouse_position()
	instance.projectile_owner = self
	get_parent().add_child(instance)
	
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
	emit_signal("hp_signal")
	if cur_hp <= 0:
		tween.stop()
		tween2.stop()
		die()

func set_knockback(do, strength, duration, direction):
	knockback = do
	knockback_strength = strength
	knockback_duration = duration
	knockback_direction = direction
	
func special(): # Kill all enemies
	for i in get_parent().get_child_count():
		if get_parent().get_child(i).is_in_group("enemy"):
			get_parent().get_child(i).handle_hit(1000)

func wiggle():
	var tween = get_tree().create_tween().set_trans(Tween.TRANS_BOUNCE)
	tween.tween_property($Sprite2D, "scale", Vector2(1.2, 1.2), 0.05)
	tween.tween_property($Sprite2D, "scale", Vector2(1, 1), 0.05)
	
func _process(_delta):
	pass


func _on_timer_timeout():
	can_shoot = true
	
func die():
	pass
