class_name GolemRetreatAttackState
extends GolemAttackState

onready var state_timer = $StateTimer
onready var attack_cooldown_timer = $AttackCooldownTimer

export var ATTACK_DELAY = 0.8

var direction_offset: float = 0

# Determines the movement of the enemy
func get_velocity(delta: float) -> Vector2:
    var distance: Vector2 =  enemy.player.global_position - enemy.global_position
    var linear_direction: Vector2 =  distance.normalized()
    linear_direction.x = linear_direction.x - direction_offset
    linear_direction.y = linear_direction.y + direction_offset
    
    return enemy.velocity.move_toward(linear_direction * -1 * enemy.MAX_SPEED,
        enemy.ACCELERATION * delta)


func attack(_delta: float) -> void:
    if attack_cooldown_timer.is_stopped():
        attack_cooldown_timer.start(ATTACK_DELAY)
        enemy.fire(550, 5)


# Receives events from the `_unhandled_input()` callback.
func handle_input(event: InputEvent) -> void:
    .handle_input(event)


# Corresponds to the `_process()` callback.
func update(delta: float) -> void:
    .update(delta)


# Corresponds to the `_physics_process()` callback.
func physics_update(delta: float) -> void:
    .physics_update(delta)
    if state_timer.is_stopped():
        transition_to("ChaseAttackState")
    else:
        enemy.update_hp(enemy.BOSS_CUR_HP + 3 * delta)
    

# Called by the state machine upon changing the active state. The `msg` parameter
# is a dictionary with arbitrary data the state can use to initialize itself.
func enter(msg := {}) -> void:
    # We must declare all the properties we access through `enemy` in the `EnemyEntity.gd` script.
    .enter(msg)
    rng.randomize()
    var time = rng.randf_range(2, 3.5)
    state_timer.start(time)
    direction_offset = rng.randf_range(-0.25, 0.25)


# Called by the state machine before changing the active state. Use this function
# to clean up the state.
func exit() -> void:
    .exit()
