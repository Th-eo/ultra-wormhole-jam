extends RayCast2D

var beamStart: Sprite2D
var beamMiddle: Sprite2D
var beamEnd: Sprite2D

var maxBeamLength: float = 200.0

func _ready():
	beamStart = $Begin
	beamMiddle = $Middle
	beamEnd = $End

func _process(delta: float):
	look_at(get_global_mouse_position())
	if Input.is_action_pressed("fire"):
		beamStart.visible = true
		beamMiddle.visible = true
		beamEnd.visible = true
		enabled = true
	else:
		beamStart.visible = false
		beamMiddle.visible = false
		beamEnd.visible = false
		enabled = false
	fireBeam()

func fireBeam():
	var collisionPosition = get_collision_point()
	var localPosition = to_local(collisionPosition)
	var beamLength = localPosition.length()
	if beamLength > maxBeamLength:
		beamLength = maxBeamLength

	beamStart.position = Vector2(10, 0)
	beamMiddle.position = Vector2(beamStart.texture.get_width(), 0)
	beamMiddle.region_rect = Rect2(0, 0, beamLength, beamMiddle.texture.get_height())
	beamEnd.position = Vector2(beamStart.texture.get_width() + beamLength+8, 0)

	# Calculate the midpoint between the start and end points
	var midpoint = (beamStart.position + beamEnd.position) / 2.0
	beamMiddle.position = midpoint
