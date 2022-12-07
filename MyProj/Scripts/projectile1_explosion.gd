extends Node2D

export var is_despawn = true
export var attack_owner = "null"


func _ready():
    if not is_despawn:
        $projectile1_explosion_sprite.play()
        if "Player" in attack_owner:
            $explosion_sfx.play()
    $despawn_timer.start()
    


func _on_despawn_timer_timeout():
    queue_free()
