extends StateMachine


# Player Projectile collides with boss
func _on_Area2D_area_entered(area: Area2D):
    if area.name == "bullet_area" and area.get_parent().projectile_owner == "Player":
        var damage = area.get_parent().damage
        area.get_parent().queue_free()
        # The boss should only take damage if they have this function.
        # Only `AttackState` has this method, so the boss is invulnerable in
        # other states.
        # We need to use methods on the current state to encapsulate state
        # transition logic
        if state.has_method('damage_boss'):
            state.damage_boss(damage)
    if area.name == "magic_area" and area.get_parent().projectile_owner == "Player":
        area.get_parent().queue_free()
        if state.has_method('damage_boss'):
            state.damage_boss(area.get_parent().damage)

func _on_BossVisibilityNotif_screen_entered():
    if state.name == "NuetralState":
        transition_to("ActivateState")