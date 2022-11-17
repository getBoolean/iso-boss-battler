extends Node2D

const projectile_scene = preload("res://Scenes/pattern_projectile.tscn")
onready var timer = $Timer
onready var rotator = $Rotator

const rot_speed = 100
const timer_wait_time = .2
const spawn_point_num = 4
const r = 100

func _ready():
    var step = 2 * PI / spawn_point_num
    for i in range(spawn_point_num):
        var point = Node2D.new()
        var pos = Vector2(r, 0).rotated(step * i)
        point.position = pos
        point.rotation = pos.angle()
        rotator.add_child(point)
        
    timer.wait_time = timer_wait_time
    timer.start()
    
func _process(delta):
    var new_rot = rotator.rotation_degrees + rot_speed * delta
    rotator.rotation_degrees = fmod(new_rot, 360)
    


func _on_Timer_timeout():
    for i in rotator.get_children():
        var projectile = projectile_scene.instance()
        get_tree().root.add_child(projectile)
        projectile.position = i.global_position
        projectile.rotation = i.global_rotation
