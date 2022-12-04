class_name EnemyEntityTwo
extends KinematicBody2D

signal boss_health_updated(new_value, old_value)
signal boss_died(difference)


# Load the projectile scene/node
const PROJECTILE_SCENE = preload("res://Scenes/Projectile.tscn")

# Load Projectile generator scene
const GENERATOR_SCENE = preload("res://Scenes/ProjectileGenerator/projectile_spawner.tscn")

onready var attack_queue = $attack_queue


# Boss Health Values
export var BOSS_MAX_HP = 200
export onready var BOSS_CUR_HP = 200

var player: Player = null


# values for speed of boss
export var ACCELERATION = 300
export var FRICTION = 400
export var MAX_SPEED = 125

#Object references to boss attributes
onready var playerDetectionZone = $Player_detection_zone
onready var enemy_sprite = $AnimatedSprite
onready var anim_player = $AnimatedSprite/AnimationPlayer


var velocity = Vector2.ZERO
var direction = 1
onready var is_alive = true

func see_player():
    if playerDetectionZone.can_see_player():
        player = playerDetectionZone.player
        if player.is_Alive:
            return true
        return false

func fire(speed: float, damage: float = 5, scale_x: float = 1.5, scale_y: float = 1.5):
    if not is_alive or not see_player():
        return
    
    var projectile = PROJECTILE_SCENE.instance()
    get_parent().add_child(projectile)
    projectile.projectile_owner = "Enemy_entity_two"
    projectile.position = global_position
    projectile.velocity = player.global_position - projectile.position
    projectile.scale.x = scale_x
    projectile.scale.y = scale_y
    projectile.damage = damage
    projectile.speed = speed
    projectile.look_at(player.global_position)
        
        
func update_hp(new_health: float):
    if new_health > BOSS_MAX_HP:
        new_health = BOSS_MAX_HP
    emit_signal("boss_health_updated", new_health, BOSS_CUR_HP)
    BOSS_CUR_HP = new_health
        
        
func kill(difference: float):
    MAX_SPEED = 0
    is_alive = false
    anim_player.play("Death")
    yield(anim_player,"animation_finished")
    emit_signal("boss_died", difference)
            
func spawn_projectile_generator(pattern_type): 
    var generator = init_generator(pattern_type)
    #generator.init(rot,timer,spawn_num,radius,life)
    add_child(generator)
    generator.global_position = global_position
    generator.global_position.y = generator.global_position.y - 50
    return generator
 
func init_generator(pattern_type):
    var generator = GENERATOR_SCENE.instance()
    if pattern_type == 1:
        generator.init(0,4,32,100,4)
    elif pattern_type == 2:
        generator.init(100,.2,4,100,4)
    elif pattern_type == 3:
        generator.init(25,.1,8,100,4)
    return generator
