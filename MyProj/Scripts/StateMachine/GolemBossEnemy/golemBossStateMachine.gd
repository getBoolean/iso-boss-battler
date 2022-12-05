extends StateMachine


# Player Projectile collides with boss
func _on_Area2D_area_entered(area: Area2D):
    if area.name == "damage_area" and area.get_parent().attack_owner == "Player":
        var proj = area.get_parent()
        if "Projectile" in proj.name:
            proj.queue_free()
        # The boss should only take damage if they have this function.
        # Only `AttackState` has this method, so the boss is invulnerable in
        # other states.
        # We need to use methods on the current state to encapsulate state
        # transition logic
        if state.has_method('damage_boss'):
            var attack: Attack = area.get_parent()
            state.damage_boss(attack.damage)

func _on_BossVisibilityNotif_screen_entered():
    if state.name == "NuetralState":
        transition_to("ActivateState")
