extends Node2D

const dash_delay = 0.5
onready var duration_timer = $dash_duration
onready var ghost_timer = $ghost_timer
onready var dust_trail = $dust_trail
onready var dust_burst = $dust_burst
var can_dash = true

var ghost_scene = preload("res://Scenes/Dash_Ghost.tscn")
var sprite

func start_dash(a_sprite, dash_duration, direction):
    self.sprite = a_sprite
    sprite.material.set_shader_param("mix_weight", 0.7)
    sprite.material.set_shader_param("whiten", true)
    duration_timer.wait_time = dash_duration
    duration_timer.start()
    ghost_timer.start()
    instance_ghost()
    
    dust_trail.restart()
    dust_trail.emitting = true 
    
    dust_burst.rotation = (direction* -1).angle()
    dust_burst.restart()
    dust_burst.emitting = true
    
func instance_ghost():
    var ghost: Sprite = ghost_scene.instance()
    get_parent().get_parent().add_child(ghost)
    
    ghost.global_position.x = global_position.x
    ghost.global_position.y = global_position.y - 38
    ghost.texture = sprite.texture
    ghost.vframes = sprite.vframes
    ghost.hframes = sprite.hframes
    ghost.frame = sprite.frame
    ghost.flip_h = sprite.flip_h
    ghost.scale.x = sprite.scale.x/2.5
    ghost.scale.y = sprite.scale.y/2.5
    
func is_dashing():
    return !duration_timer.is_stopped()

func end_dash():
    ghost_timer.stop()
    sprite.material.set_shader_param("whiten",false)
    can_dash = false
    yield(get_tree().create_timer(dash_delay), "timeout")
    can_dash = true
    


func _on_dash_duration_timeout() -> void:
    end_dash()


func _on_ghost_timer_timeout():
    instance_ghost()
