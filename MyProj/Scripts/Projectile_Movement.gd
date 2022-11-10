extends KinematicBody2D

var velocity = Vector2()
var speed = 700
var projectile_owner = null


# Called when the node enters the scene tree for the first time.
func _ready():
    pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
    var collided = move_and_collide(velocity.normalized() * delta * speed)
    if collided:
        queue_free()

# Despawn the instance once the sprite has exited the screen
func _on_VisibilityNotifier2D_screen_exited():
    queue_free()
