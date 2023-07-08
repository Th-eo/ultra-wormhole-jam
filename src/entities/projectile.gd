extends Area2D

var speed = 100
var move = true

func _ready():
	pass
	
func _process(delta):
	if move == true:
		position += transform.x * speed * delta
	await get_tree().create_timer(1).timeout
	move = false
	die()
	
func die():
	move	 = false
	$AnimationPlayer.play("death")
	await $AnimationPlayer.animation_finished
	queue_free()

func _on_area_entered(area):
	print(area)
	if area.get_parent().has_method("handle_hit"):
		area.get_parent().handle_hit()
		die()
