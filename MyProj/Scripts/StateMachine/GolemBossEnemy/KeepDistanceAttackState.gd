class_name GolemKeepDistanceAttackState
extends GolemAttackState

onready var state_timer = $StateTimer
onready var attack_cooldown_timer = $AttackCooldownTimer
onready var spike_wave_cooldown_timer: Timer = $SpikeWaveCooldownTimer
onready var spike_spawn_delay_timer: Timer = $SpikeSpawnDelayTimer



export var ATTACK_DELAY = 0.8

export var MAX_FOLLOW_DISTANCE: float = 150
export var MIN_FOLLOW_DISTANCE: float = 100
export var MIDDLE_FOLLOW_DISTANCE: float = (MAX_FOLLOW_DISTANCE + MIN_FOLLOW_DISTANCE)/2


# Determines the movement of the enemy
func get_velocity(delta: float) -> Vector2:
    var distance: Vector2 =  enemy.player.global_position - enemy.global_position
    var linear_direction: Vector2 =  distance.normalized()
    if distance.length() < MIN_FOLLOW_DISTANCE:
        return enemy.velocity.move_toward(linear_direction * -1 * enemy.MAX_SPEED, enemy.ACCELERATION * delta)
    elif distance.length() > MAX_FOLLOW_DISTANCE:
        return enemy.velocity.move_toward(linear_direction * enemy.MAX_SPEED, enemy.ACCELERATION * delta)
    else:
        var distance_to_middle = distance.length() - MIDDLE_FOLLOW_DISTANCE
        var speed_modifier: float = ease(distance_to_middle/(MIDDLE_FOLLOW_DISTANCE - MIN_FOLLOW_DISTANCE), -2)
        if distance.length() < MIN_FOLLOW_DISTANCE:
            return enemy.velocity.move_toward(linear_direction * -1 * enemy.MAX_SPEED * speed_modifier, enemy.ACCELERATION * delta)
        else:
            return enemy.velocity.move_toward(linear_direction * enemy.MAX_SPEED * speed_modifier, enemy.ACCELERATION * delta)


func attack(_delta: float) -> void:
    if attack_cooldown_timer.is_stopped():
        attack_cooldown_timer.start(ATTACK_DELAY)
        enemy.fire(550, 5)
    if spike_wave_cooldown_timer.is_stopped():
        enemy.spike_wave(spike_spawn_delay_timer)
        spike_wave_cooldown_timer.start(3)


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


# Called by the state machine upon changing the active state. The `msg` parameter
# is a dictionary with arbitrary data the state can use to initialize itself.
func enter(msg := {}) -> void:
    # We must declare all the properties we access through `enemy` in the `EnemyEntity.gd` script.
    .enter(msg)
    rng.randomize()
    var state_time = rng.randi_range(10, 15)
    state_timer.start(state_time)
    var spike_cooldown_time = rng.randi_range(4, 6)
    spike_wave_cooldown_timer.start(spike_cooldown_time)


# Called by the state machine before changing the active state. Use this function
# to clean up the state.
func exit() -> void:
    .exit()
