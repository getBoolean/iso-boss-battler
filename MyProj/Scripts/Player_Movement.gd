extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
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
        
    motion = motion.normalized()
    motion = move_and_slide(motion*movespeed)
    
    
    
    

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#    pass
