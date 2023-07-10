extends Area2D

var speed_min = 50
var speed_max = 150
var max_speed = 150 # DON'T. ASK.
var speed_variation = 0.2
var direction_variation = 0.15

var speed: float
var target_position : Vector2
var velocity: Vector2

var move = true

func _ready():
	target_position = get_global_mouse_position()
	speed = randf_range(speed_min, speed_max)
	# Apply variation to direction
	var angle_to_target = atan2(target_position.y - position.y, target_position.x - position.x)
	var random_offset = randf_range(-direction_variation, direction_variation)
	angle_to_target += random_offset
	# Calculate velocity based on direction and speed
	velocity = Vector2(cos(angle_to_target), sin(angle_to_target)) * speed
	# Apply variation to speed
	var random_speed_variation = randf_range(1 - speed_variation, 1 + speed_variation)
	velocity *= random_speed_variation
	# Limit the maximum speed
	velocity = velocity.normalized() * min(velocity.length(), max_speed)
	
func _process(delta):
	if move == true:
		# Update position
		translate(velocity * delta)
	await get_tree().create_timer(1).timeout
	move = false
	die()
	
func die():
	move	 = false
	$AnimationPlayer.play("death")
	await $AnimationPlayer.animation_finished
	queue_free()

func _on_area_entered(area):
	if area.get_parent().has_method("handle_hit"):
		area.get_parent().handle_hit(20)
		die()
