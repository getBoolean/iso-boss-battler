# Credit: https://www.gdquest.com/tutorial/godot/design-patterns/finite-state-machine/
class_name ActivateState
extends EnemyState


# Receives events from the `_unhandled_input()` callback.
func handle_input(_event: InputEvent) -> void:
    pass


# Corresponds to the `_process()` callback.
func update(_delta: float) -> void:
    pass


# Corresponds to the `_physics_process()` callback.
func physics_update(_delta: float) -> void:
    enemy.anim_player.play("Spawn")
    yield(enemy.anim_player,"animation_finished")
    state_machine.transition_to("AttackState")


# Called by the state machine upon changing the active state. The `msg` parameter
# is a dictionary with arbitrary data the state can use to initialize itself.
func enter(_msg := {}) -> void:
    # We must declare all the properties we access through `enemy` in the `EnemyEntity.gd` script.
    pass


# Called by the state machine before changing the active state. Use this function
# to clean up the state.
func exit() -> void:
    pass