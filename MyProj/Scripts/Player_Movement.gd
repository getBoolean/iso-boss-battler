extends KinematicBody2D

# Load the projectile scene/node
const projectilePath = preload("res://Scenes/Projectile.tscn")

# Player movement speed
export var MOVE_SPEED = 125

# Called when the node enters the scene tree for the first time.
func _ready():
    pass # Replace with function body.

func _physics_process(_delta : float) -> void:
    # Flip sprite if mouse passes middle of the screen
    var currPos = get_global_position()
    if((get_global_mouse_position().x > currPos.x)):
        $Sprite.flip_h = false
    else:
        $Sprite.flip_h = true

    # Handle player input
    var direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")

    if Input.is_action_just_pressed("primary_fire"):
        shoot()
    
    # Apply movement
    # linear_velocity is the velocity vector in pixels per second.
    # Unlike in move_and_collide(), you should not multiply it by
    # delta — the physics engine handles applying the velocity.
    var linear_velocity = MOVE_SPEED * direction
    var _movement = move_and_slide(linear_velocity)
    $Node2D.look_at(get_global_mouse_position())
    
    
    
func shoot():
    var projectile = projectilePath.instance()

    get_parent().add_child(projectile)
    projectile.position = $Node2D/ProjectileShootLoc.global_position
    projectile.velocity = get_global_mouse_position() - projectile.position
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#    pass
