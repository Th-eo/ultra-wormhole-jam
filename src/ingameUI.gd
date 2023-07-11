extends Control


@onready var buttons: Array = [$Buttons.get_node("1"),$Buttons.get_node("2"),$Buttons.get_node("3"),
	$Buttons.get_node("4"),$Buttons.get_node("5"),$Buttons.get_node("6")]
 
func _ready():
	# Starts at 0 tho, cause it's an array
	buttons[0].get_node("Sprite").set_texture(load("res://assets/characters/Dugtrio.png"))
	buttons[1].get_node("Sprite").set_texture(load("res://assets/characters/MrMime.png"))
	buttons[2].get_node("Sprite").set_texture(load("res://assets/characters/Wobbuffet.png"))
	buttons[3].get_node("Sprite").set_texture(load("res://assets/characters/Skarmory.png"))
	buttons[4].get_node("Sprite").set_texture(load("res://assets/characters/Gengar.png"))
	buttons[5].get_node("Sprite").set_texture(load("res://assets/characters/Squirtle.png"))
	
	var hp_emitter = get_node("Player")	
	hp_emitter.hp_signal.connect(update_hp)

func update_hp:
	
func _unhandled_input(event):
	if Input.is_action_pressed("party1"):
		buttons[0].grab_focus()
		buttons[0].set_pressed(true)
	if Input.is_action_pressed("party2"):
		buttons[1].grab_focus()
		buttons[1].set_pressed(true)
	if Input.is_action_pressed("party3"):
		buttons[2].grab_focus()
		buttons[2].set_pressed(true)
	if Input.is_action_pressed("party4"):
		buttons[3].grab_focus()
		buttons[3].set_pressed(true)
	if Input.is_action_pressed("party5"):
		buttons[4].grab_focus()
		buttons[4].set_pressed(true)
	if Input.is_action_pressed("party6"):
		buttons[5].grab_focus()
		buttons[5].set_pressed(true)
