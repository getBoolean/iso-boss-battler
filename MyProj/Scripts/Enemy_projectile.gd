extends Area2D


var move = Vector2.ZERO
var look_vec = Vector2.ZERO
var player_pos = null
var speed = 300

func _ready():
    look_vec = player_pos - global_position
    
func _physics_process(delta):
    move = Vector2.ZERO
    
    move = move.move_toward(look_vec, delta)
    move = move.normalized() * speed
    position += move
