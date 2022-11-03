extends KinematicBody2D

var velocity = Vector2()
var speed = 300
var projectile_owner = null



# Called when the node enters the scene tree for the first time.
func _ready():
    pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
   var _collision_info = move_and_collide(velocity.normalized() * delta * speed) 

# Despawn the instance once the sprite has exited the screen
func _on_VisibilityNotifier2D_screen_exited():
    queue_free()
