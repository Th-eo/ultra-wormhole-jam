extends TextureProgressBar

@export var greenTexture: Texture
@export var orangeTexture: Texture
@export var redTexture: Texture

func _ready():
	set_progress_texture(greenTexture)  # Set the initial texture

func setProgress(progress):
	visible = true
	var progressRatio = progress / 100.0
	if progressRatio >= 0.31:
		set_progress_texture(orangeTexture)
	elif progressRatio <= 0.3:
		set_progress_texture(redTexture)
	elif progressRatio >= 1.0:
		set_progress_texture(greenTexture)
	else:
		set_progress_texture(redTexture)
	set_value(progressRatio * max_value)
