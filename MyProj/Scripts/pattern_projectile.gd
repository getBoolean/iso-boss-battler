extends Node2D

const speed = 0

func _process(delta):
    position += transform.x * speed * delta


func _on_Timer_timeout():
    queue_free()
