# Credit: https://www.gdquest.com/tutorial/godot/design-patterns/finite-state-machine/
class_name TransformState
extends EnemyState


# Receives events from the `_unhandled_input()` callback.
func handle_input(_event: InputEvent) -> void:
    pass


# Corresponds to the `_process()` callback.
func update(_delta: float) -> void:
    pass


# Corresponds to the `_physics_process()` callback.
func physics_update(_delta: float) -> void:
    pass


# Called by the state machine upon changing the active state. The `msg` parameter
# is a dictionary with arbitrary data the state can use to initialize itself.
func enter(_msg := {}) -> void:
    # We must declare all the properties we access through `enemy` in the `EnemyEntity.gd` script.
    enemy.MAX_SPEED = 0
    enemy.anim_player.play("Phase_Change")
    var machine = state_machine
    yield(enemy.anim_player,"animation_finished")
    enemy.MAX_SPEED = 125
    enemy.PHASE = 2
    machine.transition_to("ChaseAttackState")


# Called by the state machine before changing the active state. Use this function
# to clean up the state.
func exit() -> void:
    pass
