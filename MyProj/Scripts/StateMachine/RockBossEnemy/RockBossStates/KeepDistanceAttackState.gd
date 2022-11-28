# Credit: https://www.gdquest.com/tutorial/godot/design-patterns/finite-state-machine/
class_name KeepDistanceAttackState
extends AttackState

onready var state_timer = $StateTimer
onready var attack_cooldown_timer = $AttackCooldownTimer

export var ATTACK_DELAY = 0.8

var rng = RandomNumberGenerator.new()

# Virtual function. Determines the movement of the enemy
func get_velocity(delta: float) -> Vector2:
    var linear_direction: Vector2 =  (enemy.player.global_position - enemy.global_position).normalized()
    
    var distance: Vector2 =  enemy.player.global_position - enemy.global_position
    print(distance.length())
    
    if distance.length() > 175:
        return enemy.velocity.move_toward(linear_direction * enemy.MAX_SPEED, enemy.ACCELERATION * delta)

    linear_direction = linear_direction * -1
    return enemy.velocity.move_toward(linear_direction * enemy.MAX_SPEED, enemy.ACCELERATION * delta)

func attack(_delta: float) -> void:
    if attack_cooldown_timer.is_stopped():
        attack_cooldown_timer.start(ATTACK_DELAY)
        enemy.fire(550, 5, 1.5, 1.5)


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
        state_machine.transition_to("ChaseAttackState")


# Called by the state machine upon changing the active state. The `msg` parameter
# is a dictionary with arbitrary data the state can use to initialize itself.
func enter(msg := {}) -> void:
    # We must declare all the properties we access through `enemy` in the `EnemyEntity.gd` script.
    .enter(msg)
    rng.randomize()
    var time = rng.randi_range(10, 15)
    state_timer.start(time)


# Called by the state machine before changing the active state. Use this function
# to clean up the state.
func exit() -> void:
    .exit()
