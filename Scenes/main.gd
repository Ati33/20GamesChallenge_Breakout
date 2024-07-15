extends Node2D

#@export var brick_scene : PackedScene didnt work tf?
@onready var brick_preload = preload("res://Scenes/brick.tscn")
var brick_instance
@onready var ball = $Ball
@onready var paddle = $Paddle
@onready var timer = $Timer
@onready var score_text = $CanvasLayer/Score
var score : int = 0
@onready var high_score_text = $CanvasLayer/HighScore
var high_score : int  = 0
@onready var life_counter_text = $CanvasLayer/LifeCounter
var life_counter : int  = 3
@onready var button = $CanvasLayer/Button
var bricks : Array
var color_array : Array = [
	Color(175, 0, 0, 255), #red
	Color(175, 0, 0, 255), #red
	Color("#fb6400"), #orange
	Color("#fb6400"), #orange
	Color(0, 170, 0 , 255), #green
	Color(0, 170, 0 , 255), #green
	Color(240, 200, 0, 255), # yellow
	Color(240, 200, 0, 255) #yellow
]
var ceiling_was_hit : bool = false
var paddle_scale : float = 1


# Called when the node enters the scene tree for the first time.
func _ready():
	ball.brick_break.connect(_on_brick_break)
	if bricks == null:
		_game_over()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _new_game():
	timer.start()
	score = 0
	high_score_text.hide()
	button.hide()
	_spawn_bricks()
	ball.SPEED = ball.START_SPEED
	life_counter = 3
	life_counter_text.text = str(life_counter)
	ceiling_was_hit == false


func _game_over():
	timer.stop()
	if ceiling_was_hit == true:
		paddle.scale *= 2
	
	if score > high_score:
		high_score = score
	
	high_score_text.text = "HS: " + str(high_score)
	high_score_text.show()
	button.show()
	ceiling_was_hit = false


func _on_button_pressed():
	_new_game()


func _set_brick_pos(obj, x, y):
	obj.position = Vector2 (x, y)


func _spawn_bricks():
	var start_pos_x = -120
	var pos_x = -120
	var pos_y = -100
	var offset_x = 17
	var offset_y = 5
	var color_counter = 0
	
	for i in range(1):
		for j in range(1):
			brick_instance = brick_preload.instantiate()
			brick_instance.position = Vector2(pos_x, pos_y)
			pos_x += offset_x
			add_child(brick_instance)
			bricks.append(brick_instance)
			var color_rect = brick_instance.get_child(0) 
			color_rect.color = color_array[color_counter]
		pos_x = start_pos_x
		brick_instance = brick_preload.instantiate()
		brick_instance.position = Vector2(-110, pos_y)
		pos_y += offset_y
		color_counter += 1


func _on_ball_area_area_entered(area):
	if area == $LoseArea:
		if life_counter > 0:
			life_counter -= 1
			life_counter_text.text = str(life_counter)
			timer.start()
	
	if area == $WallsAndCeiling/CeilingArea: 
		if ceiling_was_hit == false:
			paddle.scale /= 2
			paddle.paddle_shrink = true
			ceiling_was_hit = true
	if life_counter <= 0:
		_game_over()


func _on_brick_break():
	score += 1
	score_text.text = str(score)
	ball.SPEED += ball.ACCEL
	for brick in bricks:
			if bricks != null:
				bricks.erase(ball.collider)


func _on_timer_timeout():
	ball._new_ball()

