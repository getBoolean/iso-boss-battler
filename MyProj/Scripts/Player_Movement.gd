extends KinematicBody2D

# Load the projectile scene/node
const projectilePath = preload("res://Scenes/Projectile.tscn")

var movespeed = 500

# Offset to flip player sprite once the mouse passes halfway the player sprite on x-axis.
#TODO: Write better logic to get the midpoint on horizontal axis for player sprite
const playerSpriteOffset = 75

# Called when the node enters the scene tree for the first time.
func _ready():
    pass # Replace with function body.

func _physics_process(delta:float)->void:
    var motion = Vector2()
    var playerSpritePos = get_global_position()
    playerSpritePos.x+=playerSpriteOffset

    if((get_global_mouse_position().x > playerSpritePos.x)):
        $Sprite.flip_h = false
    else:
        $Sprite.flip_h = true

    if Input.is_action_pressed("up"):
        motion.y -=1
    if Input.is_action_pressed("down"):
        motion.y+=1
    if Input.is_action_pressed("left"):
        motion.x-=1
    if Input.is_action_pressed("right"):
        motion.x+=1
    if Input.is_action_just_pressed("ui_accept"):
        shoot()
    motion = motion.normalized()
    motion = move_and_slide(motion*movespeed)
    $Node2D.look_at(get_global_mouse_position())
    
    
func shoot():
    var projectile = projectilePath.instance()

    get_parent().add_child(projectile)
    projectile.position = $Node2D/Position2D.global_position
    projectile.velocity = get_global_mouse_position() - projectile.position
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#    pass
