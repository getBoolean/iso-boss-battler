# Credit: https://www.gdquest.com/tutorial/godot/design-patterns/finite-state-machine/
class_name AttackState
extends EnemyState

var rng = RandomNumberGenerator.new()

onready var damage_taken_timer = $DamageTakenTimer
var damage_taken_recent = 0

# Receives events from the `_unhandled_input()` callback.
func handle_input(_event: InputEvent) -> void:
    pass


# Corresponds to the `_process()` callback.
func update(_delta: float) -> void:
    pass


# Corresponds to the `_physics_process()` callback.
func physics_update(delta: float) -> void:
    if enemy.PHASE == 1:
        enemy.anim_player.play("Idle")
    elif enemy.PHASE == 2:
        enemy.anim_player.play("Idle_Phase_2")
    
    enemy.player = enemy.playerDetectionZone.player
    
    # Move towards player and shoot
    if enemy.player != null:
        enemy.velocity = get_velocity(delta)
        attack(delta)

    # Flip sprite
    if enemy.velocity.x > 0:
        enemy.enemy_sprite.flip_h = false
    if enemy.velocity.x < 0:
        enemy.enemy_sprite.flip_h = true
    
    # Phase transition
    if enemy.BOSS_CUR_HP <= .5 * enemy.BOSS_MAX_HP and enemy.phase_changed == 0:
        enemy.phase_changed = 1
        transition_to("TransformState")
        
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


func damage_boss(damage) -> void:
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
    pass
