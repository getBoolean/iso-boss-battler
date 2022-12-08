# Credit: https://www.gdquest.com/tutorial/godot/design-patterns/finite-state-machine/
class_name GolemActivateState
extends EnemyTwoState

signal show_boss_hp2(MAX_HP)
var boss2_hpbar

onready var boss = self.get_parent().get_parent()

func _ready():
    if get_tree().current_scene.name == "Level2":
        boss2_hpbar = get_node("/root/Level2/PlayerLayer/Player/HUD/GUI")
    else:
        boss2_hpbar = get_node("/root/TestScene/PlayerLayer/Player/HUD/GUI")
    var error = connect("show_boss_hp2", boss2_hpbar, "_on_ActivateState_show_boss_hp2")
    if error:
        print("connect err at: ActivateState show_boss_hp2")

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
    enemy.enemy_sprite.play("Spawn")
    yield(enemy.enemy_sprite, "animation_finished")
    emit_signal("show_boss_hp2", boss.BOSS_MAX_HP)
    transition_to("KeepDistanceAttackState")


# Called by the state machine before changing the active state. Use this function
# to clean up the state.
func exit() -> void:
    pass
