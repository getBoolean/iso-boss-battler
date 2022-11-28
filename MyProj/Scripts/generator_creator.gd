extends Node2D

const generator_scene = preload("res://Scenes/projectile_spawner.tscn")
#loads projectile spawner
func _ready():
    var gen1 = spawn(100,1,32,200)
    var gen2 = spawn(100,.1,4,200)
    
    
    
    
func spawn(rot,timer,spawn_num,radius): 
    var generator = generator_scene.instance()
    generator.init(rot,timer,spawn_num,radius)
    add_child(generator)
    generator.position = global_position
    return generator
