extends KinematicBody2D

onready var timer_node = $fire_delay_timer
onready var charged_timer = $charged_attack_timer
onready var _animation_player = $AnimationPlayer
onready var mana_regen_timer = $mana_regeneration_timer

onready var charge_shiney1 = $charge_shine_anchor/shine1
onready var charge_shiney2 = $charge_shine_anchor/shine2
onready var charge_anchor = $charge_shine_anchor

signal player_health_updated(new_value, old_value)
signal player_mp_updated(new_value, old_value)
signal not_enough_mp()
signal hit_boss(new_hp, old_hp)
signal player_died(_difference)
signal you_won(_difference)
signal paused()

# Load the projectile scene/node
# Load the magic scene/node
const PROJECTILE_SCENE = preload("res://Scenes/Projectile.tscn")
const MAGIC_ATTACK_SCENE = preload("res://Scenes/MagicAttack.tscn")



# Player movement speed
export var MOVE_SPEED = 175

#player dash variables
export var DASH_SPEED = 675
export var DASH_DURATION = .15
onready var dash = $Dash

export var PLAYER_MAX_HP = 100
export onready var PLAYER_CUR_HP = 100

export var PLAYER_MAX_MP = 100
export onready var PLAYER_CUR_MP = 100
export var ATTACK_MANA_COST = 25
export var MAX_CHARGE = 4
export var BASE_MAGIC_DAMAGE = 5
export var MANA_REGEN_RATE = 0.1
export var MANA_REGEN_HIT_COOLDOWN = 2
export var MAGIC_DAMAGE_NORMALIZER = 15

var is_Alive = true
# Timer duration
export var fire_delay_rate = 0.05

var is_paused = false
var has_won = false

# Called when the node enters the scene tree for the first time.
func _ready():
    pass # Replace with function body.
    
func _process(_delta: float):
    if not is_Alive:
        return
    # Check if the regen timer is stopped
    # If stopped and player mana < 100 then regenrate mana
    if(mana_regen_timer.get_time_left()<=0 && PLAYER_CUR_MP < PLAYER_MAX_MP):
        var old_mp = PLAYER_CUR_MP
        PLAYER_CUR_MP +=MANA_REGEN_RATE
        emit_signal("player_mp_updated", PLAYER_CUR_MP, old_mp)

    if Input.is_action_pressed("ui_left") \
        or Input.is_action_pressed("ui_right") \
        or Input.is_action_pressed("ui_up") \
        or Input.is_action_pressed("ui_down"):
        $RunSprite.show()
        $IdleSprite.hide()
        $DeathSprite.hide()
        _animation_player.play(Global.PLAYER_RUN)
    elif is_Alive:
        _animation_player.play(Global.PLAYER_IDLE)
        $RunSprite.hide()
        $IdleSprite.show()
        $DeathSprite.hide()

func _physics_process(_delta : float) -> void:
    # Flip sprite if mouse passes middle of the screen
    if not is_Alive:
        return
        
    var currPos = get_global_position()
    if((get_global_mouse_position().x > currPos.x)):
        $RunSprite.flip_h = false
        $IdleSprite.flip_h = false
    else:
        $RunSprite.flip_h = true
        $IdleSprite.flip_h = true

    # Handle player input
    var direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
    
    if Input.is_action_just_pressed("dash") and dash.can_dash and !dash.is_dashing():
        $RunSprite.show()
        $IdleSprite.hide()
        $DeathSprite.hide()
        dash.start_dash($RunSprite, DASH_DURATION, direction)
        $dash_sfx.play()
        $RunSprite.hide()
        $IdleSprite.show()
        $DeathSprite.hide()

    if Input.is_action_just_pressed("primary_fire") && timer_node.is_stopped() && !dash.is_dashing():
        shoot()
    
    # Start Timer node as soon as player holds down the secondary fire key
    if Input.is_action_just_pressed("secondary_fire"):
        charged_timer.start(MAX_CHARGE)
        charge_shiney2.visible = true
        charge_shiney2.play()
    
    # Calculate elapsed time of timer
    # Max charge can be 25(mana cost per second) * 4(elapsed time) = 100
    if Input.is_action_just_released("secondary_fire"):
        charge_shiney2.visible = false
        charge_shiney2.stop()
        var charge = MAX_CHARGE - round(charged_timer.get_time_left())
        charged_timer.stop()
        var mana_cost  = ATTACK_MANA_COST * round(charge)
        if(mana_cost <1):
            # If player holds the RMB for less than a second
            # The elapsed time is 0.xxx and manacost becomes 0
            # To solve this set mana_cost to 25 if elapsed timer time < 1sec
            mana_cost = ATTACK_MANA_COST
        magic_attack(mana_cost)
    # FOR TESTING Damage to Player, currently just a keybind.
    # Can change into player collides with boss projectile
    if Input.is_action_just_released("testing_dmg_player"):
        damage_player(5)
    if Input.is_action_just_released("testing_mp_drain"):
        use_player_mp(5)

    if Input.is_action_just_released("pause_game"):
        # Don't let player pause the game if Death or Win Overlays are in effect. 
        if(!get_node("HUD/DeathOverlay").is_visible() && !get_node("HUD/WinOverlay").is_visible()):
            emit_signal("paused")
        
    # Apply movement
    # linear_velocity is the velocity vector in pixels per second.
    # Unlike in move_and_collide(), you should not multiply it by
    # delta — the physics engine handles applying the velocity.
    var linear_velocity = DASH_SPEED * direction if dash.is_dashing() else MOVE_SPEED * direction
    var _movement = move_and_slide(linear_velocity)
    $Node2D.look_at(get_global_mouse_position())

    
func shoot():
    var projectile = PROJECTILE_SCENE.instance()
    timer_node.start(fire_delay_rate)
    get_parent().add_child(projectile)
    projectile.projectile_owner = "Player"
    
    projectile.position = $Node2D/ProjectileShootLoc.global_position
    projectile.velocity = get_global_mouse_position() - projectile.position
    projectile.damage = 3
    projectile.speed = 400
    $attack1_sfx.play()
    projectile.look_at(get_global_mouse_position())

func magic_attack(amount):
    # Check if player has atleast 1% mana left
    # If mana is already 0 don't fire
    if(use_player_mp(amount) > 0):
        var magic_attack_projectile = MAGIC_ATTACK_SCENE.instance()
        get_parent().add_child(magic_attack_projectile)
        magic_attack_projectile.projectile_owner = "Player"
        magic_attack_projectile.damage = (BASE_MAGIC_DAMAGE * amount)/MAGIC_DAMAGE_NORMALIZER
        magic_attack_projectile.position = $Node2D/ProjectileShootLoc.global_position
        #magic_attack_projectile.velocity = get_global_mouse_position() - magic_attack_projectile.position
        magic_attack_projectile.look_at(get_global_mouse_position())
    
# damage_player(damage): applies damage to the player's 
# HP based on the given amount of damage, kills 
# the player if too much damage has been taken
func damage_player(damage):
    if PLAYER_CUR_HP <= damage:
        var difference = damage - PLAYER_CUR_HP
        emit_signal("player_health_updated", 0, PLAYER_CUR_HP)
        PLAYER_CUR_HP = 0
        kill_player(difference)
    else:
        var new_hp = PLAYER_CUR_HP - damage
        emit_signal("player_health_updated", new_hp, PLAYER_CUR_HP)
        # play damage animation        
        PLAYER_CUR_HP = new_hp
    # If Player gets hit start the mana regen cooldown timer
    mana_regen_timer.start(MANA_REGEN_HIT_COOLDOWN)
        

# use_player_mp(amount): subtracts the specifiec
# amount of mana from the player, if they have it.
# if not, sends a signal that they don't
func use_player_mp(amount):
    # If player charged a shot for more than the available mana
    # Use only the remianing mana charge and alter damage accordingly
    if(PLAYER_CUR_MP - amount < 0):
        amount = PLAYER_CUR_MP
    
    if (PLAYER_CUR_MP == 0):
        # can't do anything, cause not enough mp
        emit_signal("not_enough_mp")
        return 0
    else:
        var new_mp = PLAYER_CUR_MP - amount
        emit_signal("player_mp_updated", new_mp, PLAYER_CUR_MP)
        PLAYER_CUR_MP = new_mp
        return amount

# kill_player():
# animates the player's death, calls the end screen
# difference not used, but potentially useful in future
func kill_player(_difference):
    if is_Alive && not has_won:
        is_Alive = false
        $RunSprite.hide()
        $IdleSprite.hide()
        $DeathSprite.show()
        _animation_player.play(Global.PLAYER_DEATH)
        yield(_animation_player,"animation_finished")
        emit_signal("player_died", _difference)

# passes signal through player to the UI
func _on_Enemy_entity_boss_health_updated(new_value, old_value):
    emit_signal("hit_boss", new_value, old_value)


func _on_Area2D_area_entered(area):
     if area.name == "bullet_area" and area.get_parent().projectile_owner == "Enemy_entity" and !dash.is_dashing():
        var damage = area.get_parent().damage
        area.get_parent().queue_free()
        damage_player(damage)


func _on_Enemy_entity_boss_died(_difference):
    if is_Alive && not has_won:
        has_won = true
        emit_signal("you_won", _difference)
