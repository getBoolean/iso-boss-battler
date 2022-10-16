extends KinematicBody2D

# Player movement speed
export var speed = 125

# Called when the node enters the scene tree for the first time.
func _ready():
    pass # Replace with function body.

func _physics_process(delta : float) -> void:
    # Flip sprite if mouse passes middle of the screen
    var screenSize = Vector2(0,0)
    screenSize.x = get_viewport().get_visible_rect().size.x # Get Width
    screenSize.y = get_viewport().get_visible_rect().size.y # Get Height

    if((get_global_mouse_position().x > screenSize.x/2)):
        $Sprite.flip_h = false
    else:
        $Sprite.flip_h = true

    # Handle player input
    # Movement code from https://www.davidepesce.com/2019/09/30/godot-tutorial-5-player-movement/
    var direction: Vector2
    direction.x = Input.get_action_strength("right") - Input.get_action_strength("left")
    direction.y = Input.get_action_strength("down") - Input.get_action_strength("up")
	
	# If input is digital, normalize it for diagonal movement
    if abs(direction.x) == 1 and abs(direction.y) == 1:
        direction = direction.normalized()
	
	# Apply movement
    var movement = speed * direction * delta
    var _motion = move_and_collide(movement)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#    pass
