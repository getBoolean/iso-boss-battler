# Credit: https://www.gdquest.com/tutorial/godot/design-patterns/finite-state-machine/
class_name NuetralState
extends EnemyState

signal show_boss_hp()

var boss_is_visible_by_player = false

func _ready():
    var ui_hpbar = get_node("/root/Level1/PlayerLayer/Player/HUD/GUI")
    var error = connect("show_boss_hp", ui_hpbar, "_on_NuetralState_show_boss_hp")
    if error:
        print("connect err at: NuetralState show boss hp")
    
    
# Receives events from the `_unhandled_input()` callback.
func handle_input(_event: InputEvent) -> void:
    pass


# Corresponds to the `_process()` callback.
func update(_delta: float) -> void:
    if enemy.see_player() && boss_is_visible_by_player:
        transition_to("ActivateState")
        
# shows boss hp bar after activation animation finishes        
func _on_AnimationPlayer_animation_finished(anim_name):
    if anim_name == "Spawn":
        emit_signal("show_boss_hp")

# only lets boss transisition to active when playe can see boss
func _on_BossVisibilityNotif_screen_entered():
    boss_is_visible_by_player = true

# Corresponds to the `_physics_process()` callback.
func physics_update(_delta: float) -> void:
    enemy.anim_player.play("Spawn")
    enemy.anim_player.stop(false)


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









