extends Node2D

const generator_scene = preload("res://Scenes/ProjectileGenerator/projectile_spawner.tscn")
const proj_scene = preload("res://Scenes/ProjectileGenerator/Enemy_Projectile.tscn")
#loads projectile spawner
func _ready():
    #rotation speed, rate of fire, spawn point number, radius from center, lifetime
    var gen1 = spawn_projectile_generator(75,.1,3,200,2,proj_scene)
    #var gen2 = spawn_projectile_generator(100,.1,4,200,5)
    
    
    
#arguments rotation speed, attack rate, number of spawn locations, lifetime of spawner
func spawn_projectile_generator(rot,timer,spawn_num,radius,life,proj_scene): 
    var generator = generator_scene.instance()
    generator.init(rot,timer,spawn_num,radius,life,proj_scene)
    add_child(generator)
    generator.position = global_position
    return generator
