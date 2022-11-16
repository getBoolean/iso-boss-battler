extends KinematicBody2D

var velocity = Vector2()
var speed = 700
var projectile_owner = null

const PROJECTILE_EXPLOSION = preload("res://Scenes/projectile1_explosion.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
    $projectile_despawn_timer.start()
    pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
    var collided = move_and_collide(velocity.normalized() * delta * speed)
    if collided:
        queue_free()

# Despawn the instance once the sprite has exited the screen
#func _on_VisibilityNotifier2D_screen_exited():
#    queue_free()
    
func _on_projectile_despawn_timer_timeout():
    queue_free()

# spawn explosion after being removed
func _on_Node2D_tree_exiting():
    var explosion = PROJECTILE_EXPLOSION.instance()
    var current_rotation = self.rotation_degrees
    explosion.position.x = self.position.x
    explosion.position.y = self.position.y
    explosion.rotation_degrees = current_rotation
    get_parent().call_deferred("add_child", explosion)
    pass # Replace with function body.



