extends Node2D

#loads the projectile scene
const projectile_scene = preload("res://Scenes/ProjectileGenerator/Enemy_Projectile.tscn")
#references to child nodes of timer and rotator
onready var timer = $Timer
onready var rotator = $Rotator
onready var lifetime = $lifetime

#variables for the spawner
var rot_speed
var timer_wait_time
var spawn_point_num :float 
var r
var life_length

#initialize using arguments from constructor
func init(rot, timer_arg, spawn_num, radius, life):
    rot_speed = rot
    timer_wait_time = timer_arg
    spawn_point_num = spawn_num
    r = radius
    life_length = life

func _ready():
    #sets value on circle for spawn points
    if spawn_point_num == 0:
        queue_free()
    else:
        var step = 2 * PI / spawn_point_num
        #creates new node at equally spaced points around spawner
        for i in range(spawn_point_num):
            var point = Node2D.new()
            var pos = Vector2(r, 0).rotated(step * i)
            point.position = pos
            #sets angle of point to be relative to point around spawner
            point.rotation = pos.angle()
            rotator.add_child(point)
            
        timer.wait_time = timer_wait_time
        timer.start()
        lifetime.set_wait_time(life_length)
        lifetime.start()
    
    
func _process(delta):
    var new_rot = rotator.rotation_degrees + rot_speed * delta
    rotator.rotation_degrees = fmod(new_rot, 360)
    


func _on_Timer_timeout():
    for i in rotator.get_children():
        var projectile = projectile_scene.instance()
        get_tree().root.add_child(projectile)
        projectile.position = i.global_position
        projectile.rotation = i.global_rotation
        projectile.projectile_owner = "Enemy_entity"
        projectile.scale.x = 1.1
        projectile.scale.y = 1.1


func _on_lifetime_timeout():
    queue_free()
