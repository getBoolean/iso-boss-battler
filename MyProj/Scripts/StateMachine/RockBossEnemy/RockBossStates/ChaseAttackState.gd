# Credit: https://www.gdquest.com/tutorial/godot/design-patterns/finite-state-machine/
class_name ChaseAttackState
extends AttackState

onready var state_timer = $StateTimer
onready var attack_cooldown_timer = $AttackCooldownTimer

export var CHASE_ATTACK_DELAY = 0.4

# Virtual function. Determines the movement of the enemy
func get_velocity(delta: float) -> Vector2:
    var linear_direction =  (enemy.player.global_position - enemy.global_position).normalized()
    return enemy.velocity.move_toward(linear_direction * enemy.MAX_SPEED, enemy.ACCELERATION * delta)


func attack(_delta: float) -> void:
    if attack_cooldown_timer.is_stopped():
        attack_cooldown_timer.start(CHASE_ATTACK_DELAY)
        enemy.fire()
