# Credit: https://www.gdquest.com/tutorial/godot/design-patterns/finite-state-machine/
# Generic state machine. Initializes states and delegates engine callbacks
# (_physics_process, _unhandled_input) to the active state.
class_name StateMachine
extends Node

# Emitted when transitioning to a new state.
signal transitioned(state_name)

# Path to the initial active state. We export it to be able to pick the initial state in the inspector.
# export var initial_state := NodePath('NuetralState')

# The current active state. At the start of the game, we get the `initial_state`.
onready var state: State = get_node('NuetralState')


func _ready() -> void:
    yield(owner, "ready")
    state.enter()


# The state machine subscribes to node callbacks and delegates them to the state objects.
func _unhandled_input(event: InputEvent) -> void:
    state.handle_input(event)


func _process(delta: float) -> void:
    state.update(delta)


func _physics_process(delta: float) -> void:
    state.physics_update(delta)


# This function calls the current state's exit() function, then changes the active state,
# and calls its enter function.
# It optionally takes a `msg` dictionary to pass to the next state's enter() function.
func transition_to(target_state_name: String, msg: Dictionary = {}) -> void:
    # Safety check, you could use an assert() here to report an error if the state name is incorrect.
    # We don't use an assert here to help with code reuse. If you reuse a state in different state machines
    # but you don't want them all, they won't be able to transition to states that aren't in the scene tree.
    
    assert(has_node(target_state_name),"ERROR: Node '%s' Does Not Exist." % target_state_name)

    state.exit()
    state = get_node(target_state_name) as State
    state.enter(msg)
    emit_signal("transitioned", state.name)


func queue_free():
    state.exit()
    .queue_free()
