extends Node2D

onready var immunity_timer = $immunity_timer


func start_immunity(sprite, immune_duration):
    immunity_timer.wait_time = immune_duration
    immunity_timer.start()
    
func is_immune():
    return !immunity_timer.is_stopped()


