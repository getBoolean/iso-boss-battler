class_name GolemAttackState
extends EnemyTwoState


var rng = RandomNumberGenerator.new()

onready var damage_taken_timer = $DamageTakenTimer
onready var pattern_cooldown_timer = $PatternCooldownTimer

onready var PATTERN_DELAY = 6

# If damage of charge attack exceeds this number, play different
# sound effect for boss taking damage
var ouch_dmg_threshold = 8
onready var ouch_sfx = get_node("../../ouch")
onready var big_ouch_sfx = get_node("../../big_ouch")



var damage_taken_recent = 0
var current_spawner: WeakRef = null

# Receives events from the `_unhandled_input()` callback.
func handle_input(_event: InputEvent) -> void:
    pass


# Corresponds to the `_process()` callback.
func update(_delta: float) -> void:
    pass

# Corresponds to the `_physics_process()` callback.
func physics_update(delta: float) -> void:
    enemy.anim_player.play("Idle")
    enemy.player = enemy.playerDetectionZone.player
    
    # Move towards player and shoot
    if enemy.see_player() and enemy.is_alive:
        enemy.velocity = get_velocity(delta)
        attack(delta)
        generate_pattern()
    else:
        enemy.velocity = Vector2.ZERO

    # Flip sprite
    if enemy.velocity.x > 0:
        enemy.enemy_sprite.flip_h = false
    if enemy.velocity.x < 0:
        enemy.enemy_sprite.flip_h = true
    
    enemy.velocity = enemy.move_and_slide(enemy.velocity)


# Called by the state machine upon changing the active state. The `msg` parameter
# is a dictionary with arbitrary data the state can use to initialize itself.
func enter(_msg := {}) -> void:
    damage_taken_timer.start(5)
    damage_taken_recent = 0


# Called by the state machine before changing the active state. Use this function
# to clean up the state.
func exit() -> void:
    damage_taken_timer.stop()
    damage_taken_recent = 0
    if current_spawner and current_spawner.get_ref():
        current_spawner.get_ref().stop()

func damage_boss(damage) -> void:
    if damage > ouch_dmg_threshold:
        big_ouch_sfx.play()
    else:
        ouch_sfx.play()
    
    if enemy.BOSS_CUR_HP <= damage:
        var difference = damage - enemy.BOSS_CUR_HP
        enemy.update_hp(0)
        _kill_boss(difference)
    else:
        var new_hp = enemy.BOSS_CUR_HP - damage
        # TODO: play damage animation and sound 
        damage_taken_recent = damage_taken_recent + damage
        enemy.update_hp(new_hp)
        if damage_taken_recent > 15:
            transition_to('RetreatAttackState')

# animates the boss's death, calls the win screen
# difference not used, but potentially useful in future
func _kill_boss(difference) -> void:
    transition_to_with_msg('DeadState', {'difference': difference}, false)


# Virtual function. Determines the movement of the enemy
func get_velocity(_delta: float) -> Vector2:
    return Vector2.ZERO


func attack(_delta: float) -> void:
    enemy.anim_player.play("PrimaryAttack")
    

func generate_pattern():
    if not pattern_cooldown_timer.is_stopped():
        return
    
    pattern_cooldown_timer.start(PATTERN_DELAY)
    var pattern_type = enemy.attack_queue.fire_pattern()
    current_spawner = weakref(enemy.spawn_projectile_generator(pattern_type))
