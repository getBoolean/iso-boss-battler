extends KinematicBody2D

signal player_health_updated(new_value, old_value)
signal player_mp_updated(new_value, old_value)
signal not_enough_mp()
signal hit_boss(new_hp, old_hp)

# Load the projectile scene/node
const PROJECTILE_SCENE = preload("res://Scenes/Projectile.tscn")

# Player movement speed
export var MOVE_SPEED = 125

export var PLAYER_MAX_HP = 100
export onready var PLAYER_CUR_HP = 100

export var PLAYER_MAX_MP = 100
export onready var PLAYER_CUR_MP = 100

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
        
    # FOR TESTING Damage to Player, currently just a keybind.
    # Can change into player collides with boss projectile
    if Input.is_action_just_released("testing_dmg_player"):
        damage_player(5)
    if Input.is_action_just_released("testing_mp_drain"):
        use_player_mp(5)
        
    
    # Apply movement
    # linear_velocity is the velocity vector in pixels per second.
    # Unlike in move_and_collide(), you should not multiply it by
    # delta — the physics engine handles applying the velocity.
    var linear_velocity = MOVE_SPEED * direction
    var _movement = move_and_slide(linear_velocity)
    $Node2D.look_at(get_global_mouse_position())
    
    
    
func shoot():
    var projectile = PROJECTILE_SCENE.instance()

    get_parent().add_child(projectile)
    projectile.position = $Node2D/ProjectileShootLoc.global_position
    projectile.velocity = get_global_mouse_position() - projectile.position
    
# damage_player(damage): applies damage to the player's 
# HP based on the given amount of damage, kills 
# the player if too much damage has been taken
func damage_player(damage):
    if PLAYER_CUR_HP < damage:
        var difference = damage - PLAYER_CUR_HP
        emit_signal("player_health_updated", 0, PLAYER_CUR_HP)
        PLAYER_CUR_HP = 0
        kill_player(difference)
    else:
        var new_hp = PLAYER_CUR_HP - damage
        emit_signal("player_health_updated", new_hp, PLAYER_CUR_HP)
        # play damage animation        
        PLAYER_CUR_HP = new_hp

# use_player_mp(amount): subtracts the specifiec
# amount of mana from the player, if they have it.
# if not, sends a signal that they don't
func use_player_mp(amount):
    if PLAYER_CUR_MP < amount:
        # can't do anything, cause not enough mp
        emit_signal("not_enough_mp")
        pass
    else:
        var new_mp = PLAYER_CUR_MP - amount
        emit_signal("player_mp_updated", new_mp, PLAYER_CUR_MP)
        PLAYER_CUR_MP = new_mp

# kill_player():
# animates the player's death, calls the end screen
# difference not used, but potentially useful in future
func kill_player(difference):
    pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#    pass

# passes signal through player to the UI
func _on_Enemy_entity_boss_health_updated(new_value, old_value):
    emit_signal("hit_boss", new_value, old_value)
