# Credit: https://www.gdquest.com/tutorial/godot/design-patterns/finite-state-machine/
# Virtual base class for all states. The parent MUST be a `StateMachine` for
# state transitions to work
class_name State
extends Node

func transition_to(target_state_name: String, only_if_current: bool = false):
    transition_to_with_msg(target_state_name, {}, only_if_current)

func transition_to_with_msg(target_state_name: String, msg: Dictionary = {}, only_if_current: bool = false):
    var state_machine = get_parent()
    assert(state_machine,"ERROR: Node Parent Does Not Exist.")
    
    if state_machine && state_machine.has_method('transition_to') \
        && (not only_if_current || (self == state_machine.state)):
        state_machine.transition_to(target_state_name, msg)


# Virtual function. Receives events from the `_unhandled_input()` callback.
func handle_input(_event: InputEvent) -> void:
    pass


# Virtual function. Corresponds to the `_process()` callback.
func update(_delta: float) -> void:
    pass


# Virtual function. Corresponds to the `_physics_process()` callback.
func physics_update(_delta: float) -> void:
    pass


# Virtual function. Called by the state machine upon changing the active state. The `msg` parameter
# is a dictionary with arbitrary data the state can use to initialize itself.
func enter(_msg := {}) -> void:
    pass


# Virtual function. Called by the state machine before changing the active state. Use this function
# to clean up the state.
func exit() -> void:
    pass
