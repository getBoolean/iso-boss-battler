extends KinematicBody2D

var velocity = Vector2()
var speed = 0
var projectile_owner = null
var projectile_type = "MAGIC"
var damage = 5


# Called when the node enters the scene tree for the first time.
func _ready():
    $magic_sprite.play()
    pass

func _on_magic_sprite_animation_finished():
    queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _physics_process(delta):
#    var _collided = move_and_collide(velocity.normalized() * delta * speed)

# Despawn the instance once the sprite has exited the screen
func _on_VisibilityNotifier2D_screen_exited():
    queue_free()



