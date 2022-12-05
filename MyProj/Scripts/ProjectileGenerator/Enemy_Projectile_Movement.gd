extends MovingAttack

const PROJECTILE_EXPLOSION = preload("res://Scenes/projectile1_explosion.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
    $projectile_despawn_timer.start()
    velocity = Vector2()
    speed = 550
    attack_owner = "Enemy_entity"
    is_despawn = false
    damage = 5


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
    position += transform.x * speed * delta
    var collided = move_and_collide(velocity.normalized() * delta * speed)
    if collided:
        is_despawn = false
        queue_free()

# Despawn the instance once the sprite has exited the screen
#func _on_VisibilityNotifier2D_screen_exited():
#    queue_free()
    
func _on_projectile_despawn_timer_timeout():
    is_despawn = true
    queue_free()

# spawn explosion after being removed
func _on_Node2D_tree_exiting():
    var explosion = PROJECTILE_EXPLOSION.instance()
    var current_rotation = self.rotation_degrees
    explosion.position.x = self.position.x
    explosion.position.y = self.position.y
    explosion.rotation_degrees = current_rotation
    explosion.is_despawn = self.is_despawn
    get_parent().call_deferred("add_child", explosion)
    pass # Replace with function body.
