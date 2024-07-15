extends StaticBody2D

const SPEED : int = 250.0
var paddle_width : float
var paddle_scale
var paddle_shrink : bool = false


func _ready():
	paddle_width = $ColorRect.get_size().x


func _process(delta):
	if Input.is_action_pressed("ui_left"):
		position.x -= SPEED * delta
	if Input.is_action_pressed("ui_right"):
		position.x += SPEED * delta

	if paddle_shrink == true:
		position.x = clamp(position.x, -125, 110 - paddle_width / 32)
	elif paddle_shrink == false:
		position.x = clamp(position.x, -125, 110 - paddle_width / 2)


