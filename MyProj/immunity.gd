extends Node2D

onready var immunity_timer = $immunity_timer


func start_immunity(run_sprite, idle_sprite, immune_duration):
    run_sprite.material.set_shader_param("mix_weight", 0.7)
    run_sprite.material.set_shader_param("whiten", true)
    idle_sprite.material.set_shader_param("mix_weight", 0.7)
    idle_sprite.material.set_shader_param("whiten", true)
    immunity_timer.wait_time = immune_duration
    immunity_timer.start()
    yield(immunity_timer,"timeout")
    run_sprite.material.set_shader_param("whiten", false)
    idle_sprite.material.set_shader_param("whiten", false)
    
func is_immune():
    return !immunity_timer.is_stopped()


