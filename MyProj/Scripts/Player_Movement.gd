extends KinematicBody2D

# Player movement speed
export var MOVE_SPEED = 125

# Called when the node enters the scene tree for the first time.
func _ready():
    pass # Replace with function body.

func _physics_process(_delta : float) -> void:
    # Flip sprite if mouse passes middle of the screen
    var screenSize = Vector2(0,0)
    screenSize.x = get_viewport().get_visible_rect().size.x # Get Width
    screenSize.y = get_viewport().get_visible_rect().size.y # Get Height

    if((get_global_mouse_position().x > screenSize.x/2)):
        $Sprite.flip_h = false
    else:
        $Sprite.flip_h = true

    # Handle player input
    var direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
    
    # Apply movement
    # linear_velocity is the velocity vector in pixels per second.
    # Unlike in move_and_collide(), you should not multiply it by
    # delta — the physics engine handles applying the velocity.
    var linear_velocity = MOVE_SPEED * direction
    var _movement = move_and_slide(linear_velocity)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#    pass
