class_name GolemChaseAttack
extends GolemAttackState

onready var state_timer = $StateTimer
onready var attack_cooldown_timer = $AttackCooldownTimer
onready var spike_wave_cooldown_timer: Timer = $SpikeWaveCooldownTimer
onready var spike_spawn_delay_timer: Timer = $SpikeSpawnDelayTimer


export var CHASE_ATTACK_DELAY = 0.3
export var CHASE_PATTERN_DELAY = 6
export var SPIKE_WAVE_DELAY = 3
export var SPIKE_SPAWN_DELAY = 0.08

# Determines the movement of the enemy
func get_velocity(delta: float) -> Vector2:
    var distance =  enemy.player.global_position - enemy.global_position
    var linear_direction =  distance.normalized()
    var speed_buff = 1.2
    
    return enemy.velocity.move_toward(linear_direction * enemy.MAX_SPEED * speed_buff, enemy.ACCELERATION * delta)


func attack(_delta: float) -> void:
    if attack_cooldown_timer.is_stopped():
        attack_cooldown_timer.start(CHASE_ATTACK_DELAY)
        enemy.fire(600, 5, Vector2(1.2, 1.2))
    if spike_wave_cooldown_timer.is_stopped():
        var degree_size: float = rng.randf_range(120, 180)
        var max_distance: float = rng.randf_range(600, 700)
        var degrees_per_spike_line: float = rng.randf_range(18, 20)
        var spike_separator_distance: float = 40
        var spawn_delay: float = SPIKE_SPAWN_DELAY
        enemy.spike_wave(spike_spawn_delay_timer, degree_size,
            max_distance, degrees_per_spike_line,
            spike_separator_distance,
            spawn_delay)
        spike_wave_cooldown_timer.start(SPIKE_WAVE_DELAY)


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
        transition_to("KeepDistanceAttackState")


# Called by the state machine upon changing the active state. The `msg` parameter
# is a dictionary with arbitrary data the state can use to initialize itself.
func enter(msg := {}) -> void:
    # We must declare all the properties we access through `enemy` in the `EnemyEntity.gd` script.
    .enter(msg)
    rng.randomize()
    var state_time = rng.randf_range(3, 5)
    state_timer.start(state_time)
    var spike_cooldown_time = rng.randf_range(2, 3)
    spike_wave_cooldown_timer.start(spike_cooldown_time)


# Called by the state machine before changing the active state. Use this function
# to clean up the state.
func exit() -> void:
    .exit()
