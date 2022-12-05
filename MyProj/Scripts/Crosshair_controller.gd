extends AnimatedSprite

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
    Input.mouse_mode = Input.MOUSE_MODE_HIDDEN

func _exit_tree():
    Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
    var mouse_loc = get_global_mouse_position()
    self.position = mouse_loc

    if Input.is_action_pressed("primary_fire"):
        self.playing = false
        self.frame = 0
        
    if Input.is_action_just_released("primary_fire"):
        self.frame = 3
        self.playing = true
    
    if Input.is_action_pressed("primary_fire"): 
        self.playing = false
        self.frame = 0       
    if Input.is_action_just_released("secondary_fire"):
        self.frame = 3
        self.playing = true
