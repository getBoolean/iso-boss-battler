class_name Player
extends KinematicBody2D

onready var timer_node = $fire_delay_timer
onready var charged_timer = $charged_attack_timer
onready var _animation_player = $AnimationPlayer
onready var mana_regen_timer = $mana_regeneration_timer
onready var shield_animator = $ShieldAnimatedSprite
onready var shield_timer = $shield_timer
onready var hitbox = $Area2D/CollisionShape2D

onready var immunity = $immunity

onready var charge_shiney = get_parent().get_node("charge_shine_anchor/shine")
onready var charge_anchor = get_parent().get_node("charge_shine_anchor")
onready var charge_sfx = $laser_charge
onready var second_shot_sfx = $laser_fire
onready var oof1 = $player_ouches/ouch1
onready var oof2 = $player_ouches/ouch2
onready var oof3 = $player_ouches/ouch3
onready var proj_hit = $player_ouches/projectile_hit

signal player_health_updated(new_value, old_value)
signal player_mp_updated(new_value, old_value)
signal not_enough_mp()
signal hit_boss(new_hp, old_hp)
signal player_died(difference)
signal player_won(difference)
signal boss_died(difference)
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
export var IMMUNE_DURATION = .35
onready var dash = $Dash

export var PLAYER_MAX_HP = 100
export onready var PLAYER_CUR_HP = 100

export var PLAYER_MAX_MP = 100
export onready var PLAYER_CUR_MP = 100
export var ATTACK_MANA_COST = 25
export var MAX_CHARGE = 4
export var BASE_MAGIC_DAMAGE = 5
export var MANA_REGEN_RATE = 0.05
export var MANA_REGEN_HIT_COOLDOWN = 2
export var MAGIC_DAMAGE_NORMALIZER = 15
export var SHIELD_MANA_COST = 25
export var SHIELD_TIME = 4.65

export var is_Alive = true
# Timer duration
export var fire_delay_rate = 0.05

export var is_paused = false
export var has_won = false

# Shield Status
var is_shield_active = false

# Called when the node enters the scene tree for the first time.
func _ready():
    pass # Replace with function body.
    
func _process(_delta: float):
    if not is_Alive:
        return
    
    # Check if the regen timer is stopped and shield is not active
    # If stopped and player mana < 100 then regenrate mana
    _mana_regen()

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
        charge_shiney.visible = true
        charge_shiney.play()
        charge_sfx.play()
    
    # Calculate elapsed time of timer
    # Max charge can be 25(mana cost per second) * 4(elapsed time) = 100
    if Input.is_action_just_released("secondary_fire"):
        charge_shiney.visible = false
        charge_shiney.stop()
        charge_sfx.stop()
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

    if Input.is_action_just_released("Activate_Shield") and !is_shield_active:
        activate_shield()


# Check if the regen timer is stopped and shield is not active
# If stopped and player mana < 100 then regenrate mana
func _mana_regen():
    if is_shield_active \
        || mana_regen_timer.get_time_left() > 0 \
        || PLAYER_CUR_MP >= PLAYER_MAX_MP:
        return
    
    var old_mp = PLAYER_CUR_MP
    PLAYER_CUR_MP +=MANA_REGEN_RATE
    if PLAYER_CUR_MP > PLAYER_MAX_MP:
        PLAYER_CUR_MP = PLAYER_MAX_MP
    emit_signal("player_mp_updated", PLAYER_CUR_MP, old_mp)


func activate_shield():
    if PLAYER_CUR_MP >= SHIELD_MANA_COST:
        use_player_mp(SHIELD_MANA_COST)
        shield_timer.start(SHIELD_TIME)
        is_shield_active = true
        shield_animator.show()
        shield_animator.play("Activate Shield")
        yield(shield_animator,"animation_finished")
        shield_animator.play("Idle")
        
func shoot():
    var projectile = PROJECTILE_SCENE.instance()
    timer_node.start(fire_delay_rate)
    get_parent().add_child(projectile)
    projectile.attack_owner = "Player"
    
    projectile.position = $Node2D/ProjectileShootLoc.global_position
    projectile.velocity = get_global_mouse_position() - projectile.position
    projectile.damage = 3
    projectile.speed = 400
    $attack1_sfx.play()
    projectile.look_at(get_global_mouse_position())

func magic_attack(mana_cost):
    # Check if player has atleast 1% mana left
    # If mana is already 0 don't fire
    var used_mana = use_player_mp(mana_cost)
    if used_mana <= 0:
        return
    
    var magic_attack_projectile: MovingAttack = MAGIC_ATTACK_SCENE.instance()
    get_parent().add_child(magic_attack_projectile)
    magic_attack_projectile.attack_owner = "Player"
    magic_attack_projectile.damage = (BASE_MAGIC_DAMAGE * used_mana)/MAGIC_DAMAGE_NORMALIZER
    magic_attack_projectile.position = $Node2D/ProjectileShootLoc.global_position
    magic_attack_projectile.look_at(get_global_mouse_position())
    second_shot_sfx.play()

# damage_player(damage): applies damage to the player's 
# HP based on the given amount of damage, kills 
# the player if too much damage has been taken
func damage_player(damage):
    var sfx_choice = (randi() % 3) + 1
    if is_Alive:
        match sfx_choice:
            1: oof1.play()
            2: oof2.play()
            3: oof3.play()
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
        immunity.start_immunity($RunSprite, $IdleSprite, IMMUNE_DURATION)
        
        
        
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
        if get_tree().get_current_scene().name == "Level1":
            Global.player_died_level1 = true

# passes signal through player to the UI
func _on_Enemy_entity_boss_health_updated(new_value, old_value):
    emit_signal("hit_boss", new_value, old_value)


func _on_Area2D_area_entered(area):
    # area is an attack node
    if area.name != "damage_area" or not (area.get_parent() is Attack):
        return
        
    var attack: Attack = area.get_parent()
    # attack is from enemy and player is vulnerable
    if attack.attack_owner != "Enemy_entity" or dash.is_dashing() or immunity.is_immune():
        return
    
    # remove only moving attacks
    if attack is MovingAttack:
        attack.queue_free()
        proj_hit.play()
    
    if is_shield_active:
        return
    
    damage_player(attack.damage)
    


func _on_Enemy_entity_boss_died(difference: float, is_last_boss: bool) -> void:
    if not is_Alive || has_won:
        return
    
    has_won = true
    if is_last_boss:
        emit_signal("player_won", difference)
        return
        
    emit_signal("boss_died", difference)


# Called when shield timer has expired
func _on_shield_timer_timeout():
    shield_animator.stop()
    shield_animator.play("Deactivate Shield")
    yield(shield_animator,"animation_finished")
    is_shield_active = false
    shield_animator.stop()
