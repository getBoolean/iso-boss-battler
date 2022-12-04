# Credit: https://www.gdquest.com/tutorial/godot/design-patterns/finite-state-machine/
class_name ChaseAttackState
extends AttackState

onready var state_timer = $StateTimer
onready var attack_cooldown_timer = $AttackCooldownTimer

export var CHASE_ATTACK_DELAY = 0.3
export var CHASE_PATTERN_DELAY = 6

# Determines the movement of the enemy
func get_velocity(delta: float) -> Vector2:
    var distance =  enemy.player.global_position - enemy.global_position
    var linear_direction =  distance.normalized()
    var speed_buff = 1.2
    
    return enemy.velocity.move_toward(linear_direction * enemy.MAX_SPEED * speed_buff, enemy.ACCELERATION * delta)


func attack(_delta: float) -> void:
    if attack_cooldown_timer.is_stopped():
        attack_cooldown_timer.start(CHASE_ATTACK_DELAY)
        enemy.fire(600, 5, 1.2, 1.2)
        
#func generate_pattern(_delta: float) -> void:
 #   if pattern_cooldown_timer.is_stopped():
  #      pattern_cooldown_timer.start(CHASE_PATTERN_DELAY)
   #     var pattern_type = enemy.attack_queue.fire_pattern()
    #    var _pattern = enemy.spawn_projectile_generator(pattern_type)
        #if enemy.PHASE == 2:
        #    var pattern_type_2 = enemy.attack_queue.fire_pattern()
        #    var _pattern2 = enemy.spawn_projectile_generator(pattern_type_2)
        
    


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
    var time = rng.randi_range(3, 5)
    state_timer.start(time)


# Called by the state machine before changing the active state. Use this function
# to clean up the state.
func exit() -> void:
    .exit()
