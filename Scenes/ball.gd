extends CharacterBody2D

signal brick_break

var SPEED : int = 200
const START_SPEED : int = 200
const ACCEL : int = 5
var dir : Vector2
const MAX_X_VECTOR : int = 1
var paddle_width : float
@onready var main = $".."
const NEW_BALL_POS : Vector2 = Vector2(0, 0)
var collider

func _ready():
	paddle_width = $"../Paddle/ColorRect".get_size().x


func _physics_process(delta):
	var collision = move_and_collide(dir * SPEED * delta)
	var brick_collider
	if collision:
		collider = collision.get_collider()
		if collider == $"../Paddle":
			dir = _new_direction(collider)
		elif collider == $"../WallsAndCeiling":
			dir = dir.bounce(collision.get_normal())
		elif collider.is_in_group("BricksGroup"):
			collider.hit()
			dir = dir.bounce(collision.get_normal())
			brick_break.emit()


func _new_direction(collider):
	var ball_x = position.x
	var pad_x = collider.position.x
	var distance = ball_x - pad_x
	var new_dir = Vector2()
	#flip after bounce
	if dir.y > 0:
		new_dir.y = -1
	else:
		new_dir.y = 1
	new_dir.x = (distance / paddle_width / 2) * MAX_X_VECTOR
	return new_dir.normalized()


func _new_ball():
	position = NEW_BALL_POS
	dir = _random_direction()


func _random_direction():
	var new_dir = Vector2()
	new_dir.y = 1
	new_dir.x = randf_range(-0.5, 0.5)
	return new_dir.normalized()

