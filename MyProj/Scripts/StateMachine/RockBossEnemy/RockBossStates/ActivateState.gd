# Credit: https://www.gdquest.com/tutorial/godot/design-patterns/finite-state-machine/
class_name ActivateState
extends EnemyState

signal show_boss_hp(MAX_HP)

onready var boss = self.get_parent().get_parent()

func _ready():
    var lvl1_hpbar = get_node("/root/Level1/PlayerLayer/Player/HUD/GUI")
    var error = connect("show_boss_hp", lvl1_hpbar, "_on_ActivateState_show_boss_hp")
    if error:
        print("connect err at: ActivateState show boss hp")
    
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
    enemy.anim_player.play("Spawn")
    yield(enemy.anim_player, "animation_finished")
    emit_signal("show_boss_hp", boss.BOSS_MAX_HP)
    transition_to("KeepDistanceAttackState")


# Called by the state machine before changing the active state. Use this function
# to clean up the state.
func exit() -> void:
    pass
