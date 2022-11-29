extends Node2D

const generator_scene = preload("res://Scenes/projectile_spawner.tscn")
#loads projectile spawner
func _ready():
    var gen1 = spawn_projectile_generator(100,1,32,200,1)
    var gen2 = spawn_projectile_generator(100,.1,4,200,5)
    
    
    
#arguments rotation speed, attack rate, number of spawn locations, lifetime of spawner
func spawn_projectile_generator(rot,timer,spawn_num,radius,life): 
    var generator = generator_scene.instance()
    generator.init(rot,timer,spawn_num,radius,life)
    add_child(generator)
    generator.position = global_position
    return generator
