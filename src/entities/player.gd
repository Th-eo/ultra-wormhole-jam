class_name Player
extends CharacterBody2D

const SPEED = 300.0
var can_move = true # Variable to lock player input?

func _ready():
	$AnimationPlayer.play("idle") # TODO

func _physics_process(delta):
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
	if Input.is_action_just_pressed("fire"):
		fire()
		wiggle() # Scale wiggle, just for input feedback
		# Also the word wiggle is fun

func move():
	var x_direction = Input.get_axis("left", "right")
	var y_direction = Input.get_axis("up", "down")
	if x_direction:
		velocity.x = x_direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	if y_direction:
		velocity.y = y_direction * SPEED
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
	get_parent().add_child(instance)

func wiggle():
	var tween = get_tree().create_tween().set_trans(Tween.TRANS_BOUNCE)
	tween.tween_property($Sprite2D, "scale", Vector2(1.2, 1.2), 0.05)
	tween.tween_property($Sprite2D, "scale", Vector2(1, 1), 0.05)
	
func _process(delta):
	pass
