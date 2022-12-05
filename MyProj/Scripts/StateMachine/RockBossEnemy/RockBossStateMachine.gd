extends StateMachine

# If damage of charge attack exceeds this number, play different
# sound effect for boss taking damage
var ouch_dmg_threshold = 8

onready var ouch_sfx = get_parent().get_node("ouch")
onready var big_ouch_sfx = get_parent().get_node("big_ouch")

# Player Projectile collides with boss
func _on_Area2D_area_entered(area: Area2D):
    if area.name == "damage_area" and area.get_parent().attack_owner == "Player":
        area.get_parent().queue_free()
        # The boss should only take damage if they have this function.
        # Only `AttackState` has this method, so the boss is invulnerable in
        # other states.
        # We need to use methods on the current state to encapsulate state
        # transition logic
        if state.has_method('damage_boss'):
            var attack: Attack = area.get_parent()
            state.damage_boss(attack.damage)
            if attack.damage > ouch_dmg_threshold:
                big_ouch_sfx.play()
            else:
                ouch_sfx.play()

# only lets boss transisition to activate when player can see boss
func _on_BossVisibilityNotif_screen_entered():
    if state.name == "NuetralState":
        transition_to("ActivateState")
