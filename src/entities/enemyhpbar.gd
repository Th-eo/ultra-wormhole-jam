extends TextureProgressBar

@export var greenTexture: Texture
@export var orangeTexture: Texture
@export var redTexture: Texture

func _ready():
	set_progress_texture(greenTexture)  # Set the initial texture

func setProgress(progress):
	visible = true
	if progress / 100 >= 0.31:  # Swap to orange texture when progress is 31% or higher
		set_progress_texture(orangeTexture)
	elif progress / 100 <= 0.3:  # Swap to red texture when progress is 30% or lower
		set_progress_texture(redTexture)
	elif progress / 100 >= 1:
		set_progress_texture(greenTexture)
	else:  # If this somehow fails, use red texture
		set_progress_texture(redTexture)
	set_value((progress / 100) * max_value)
	print(value)
