class_name GolemNeutralState 
extends EnemyTwoState

# Corresponds to the `_process()` callback.
func update(_delta: float) -> void:
    if enemy.see_player():
        transition_to("ActivateState")


# Corresponds to the `_physics_process()` callback.
func physics_update(_delta: float) -> void:
    pass
    


# Called by the state machine upon changing the active state. The `msg` parameter
# is a dictionary with arbitrary data the state can use to initialize itself.
#
# Upon entering the state, we set the Enemy node's velocity to zero.
func enter(_msg := {}) -> void:
    # We must declare all the properties we access through `owner` in the `Player.gd` script.
    enemy.velocity = Vector2.ZERO
    


# Called by the state machine before changing the active state. Use this function
# to clean up the state.
func exit() -> void:
    pass
