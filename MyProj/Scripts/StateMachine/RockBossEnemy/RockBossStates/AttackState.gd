# Credit: https://www.gdquest.com/tutorial/godot/design-patterns/finite-state-machine/
class_name AttackState
extends EnemyState

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
        var linear_direction =  (enemy.player.global_position - enemy.global_position).normalized()
        enemy.velocity = enemy.velocity.move_toward(linear_direction * enemy.MAX_SPEED, enemy.ACCELERATION * delta)
        if enemy.timer_node.is_stopped():
            enemy.fire()

    # Flip sprite
    if enemy.velocity.x > 0:
        enemy.enemy_sprite.flip_h = false
    if enemy.velocity.x < 0:
        enemy.enemy_sprite.flip_h = true
    
    # Phase transition
    if enemy.BOSS_CUR_HP <= .5 * enemy.BOSS_MAX_HP and enemy.phase_changed == 0:
        enemy.phase_changed = 1
        state_machine.transition_to("TransformState")
        
    enemy.velocity = enemy.move_and_slide(enemy.velocity)


# Called by the state machine upon changing the active state. The `msg` parameter
# is a dictionary with arbitrary data the state can use to initialize itself.
func enter(_msg := {}) -> void:
    # We must declare all the properties we access through `enemy` in the `EnemyEntity.gd` script.
    pass


# Called by the state machine before changing the active state. Use this function
# to clean up the state.
func exit() -> void:
    pass


func damage_boss(damage):
    if enemy.BOSS_CUR_HP <= damage:
        var difference = damage - enemy.BOSS_CUR_HP
        enemy.update_hp(0)
        kill_boss(difference)
    else:
        var new_hp = enemy.BOSS_CUR_HP - damage
        # TODO: play damage animation and sound 
        enemy.update_hp(new_hp)      


# animates the boss's death, calls the win screen
# difference not used, but potentially useful in future
func kill_boss(difference):
    state_machine.transition_to('DeadState', {'difference': difference})
