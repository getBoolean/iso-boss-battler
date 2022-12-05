extends MovingAttack

var projectile_type = "MAGIC"

# Called when the node enters the scene tree for the first time.
func _ready():
    speed = 0
    velocity = Vector2()
    damage = 5
    $magic_sprite.play()

func _on_magic_sprite_animation_finished():
    queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _physics_process(delta):
#    var _collided = move_and_collide(velocity.normalized() * delta * speed)

# Despawn the instance once the sprite has exited the screen
func _on_VisibilityNotifier2D_screen_exited():
    queue_free()



