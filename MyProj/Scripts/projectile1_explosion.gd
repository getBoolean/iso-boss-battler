extends Node2D

export var is_despawn = true
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
    if not is_despawn:
        $projectile1_explosion_sprite.play()
        $explosion_sfx.play()
    $despawn_timer.start()
    
    pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#    pass


func _on_despawn_timer_timeout():
    queue_free()
