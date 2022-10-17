extends KinematicBody2D

var velocity = Vector2()
var speed = 300



# Called when the node enters the scene tree for the first time.
func _ready():
    pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
   var collision_info = move_and_collide(velocity.normalized() * delta * speed) 
   if(collision_info):
    print(collision_info)

# Despawn the instance once the sprite has exited the screen
func _on_VisibilityNotifier2D_screen_exited():
    queue_free()