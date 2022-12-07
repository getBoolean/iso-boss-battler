class_name EnemyEntityTwo
extends KinematicBody2D

signal boss_health_updated(new_value, old_value)
signal boss_died(difference, is_last_boss)


# Load the projectile scene/node
const PROJECTILE_SCENE = preload("res://Scenes/Enemy2Projectile.tscn")
const SPIKE_ATTACK_SCENE = preload("res://Scenes/SpikeAttack/EnemySpikeAttack.tscn")
const PROJECTILE_GEND_SCENE = preload("res://Scenes/ProjectileGenerator/Enemy2Projectile.tscn")

# Load Projectile generator scene
const GENERATOR_SCENE = preload("res://Scenes/ProjectileGenerator/projectile_spawner.tscn")

onready var attack_queue = $attack_queue


# Boss Health Values
export var BOSS_MAX_HP = 200
export onready var BOSS_CUR_HP = 200

var player: Player = null

onready var death_sfx = $death_sfx

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


func spike_wave(spawn_delay_timer: Timer, degree_size: float = 80,
        max_distance: float = 300, degrees_per_spike_line: float = 16,
        spike_separator_distance: float = 40,
        spawn_delay: float = 0.1):
    assert(not degrees_per_spike_line == 0, "degrees_per_spike cannot be 0")
    if not is_alive or not see_player():
        return
    
    enemy_sprite.play("SpikeAttack")
    var starting_position = Vector2(global_position.x, global_position.y)
    starting_position.y = starting_position.y - 65
    var boss_to_player_direction = (player.hitbox.global_position - starting_position).normalized()
    starting_position = starting_position + boss_to_player_direction * 70
    boss_to_player_direction = (player.hitbox.global_position - starting_position).normalized()
    
    var spike_lines = int(floor(degree_size/degrees_per_spike_line))
    var spikes_per_line = int(floor(max_distance/spike_separator_distance))
    
    var angle_padding = fmod(degree_size, degrees_per_spike_line)/2
    var start_direction = boss_to_player_direction.rotated(deg2rad(-degree_size/2 + angle_padding))

    for spike_number in range(1, spikes_per_line + 1):
        spawn_delay_timer.start(spawn_delay)
        var distance = spike_number * spike_separator_distance
        for line_number in range(spike_lines):
            var line_direction = start_direction.rotated(deg2rad(line_number * degrees_per_spike_line))
            var position = starting_position + line_direction * distance
            spawnSpike(position)
        yield(spawn_delay_timer, "timeout")


func spawnSpike(position: Vector2, damage: float = 5.0, scale: Vector2 = Vector2(1, 1)):
    if not is_alive:
        return
    
    var attack: SpikeAttack = SPIKE_ATTACK_SCENE.instance()
    attack.attack_owner = "Enemy_entity"
    attack.position = position
    attack.damage = damage
    attack.scale = scale
    get_parent().add_child(attack)


func fire(speed: float, damage: float = 5, scale: Vector2 = Vector2(1.5, 1.5)):
    if not is_alive or not see_player():
        return

    var projectile = PROJECTILE_SCENE.instance()
    enemy_sprite.play("PrimaryAttack")
    get_parent().add_child(projectile)
    projectile.attack_owner = "Enemy_entity"
    projectile.position = global_position
    projectile.position.y = projectile.position.y - 35
    projectile.velocity = player.hitbox.global_position - projectile.position
    projectile.scale = scale
    projectile.damage = damage
    projectile.speed = speed
    projectile.look_at(player.hitbox.global_position)
        
        
func update_hp(new_health: float):
    if new_health > BOSS_MAX_HP:
        new_health = BOSS_MAX_HP
    emit_signal("boss_health_updated", new_health, BOSS_CUR_HP)
    BOSS_CUR_HP = new_health
        
        
func kill(difference: float):
    MAX_SPEED = 0
    is_alive = false
    enemy_sprite.play("Death")
    death_sfx.play()
    yield(enemy_sprite,"animation_finished")
    emit_signal("boss_died", difference, true)
            
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
        generator.init(0,4,32,100,4,PROJECTILE_GEND_SCENE)
    elif pattern_type == 2:
        generator.init(25,.2,4,100,4,PROJECTILE_GEND_SCENE)
    elif pattern_type == 3:
        generator.init(-45,.15,3,100,4,PROJECTILE_GEND_SCENE)
    elif pattern_type == 4:
        generator.init(0,2,100,100,8,PROJECTILE_GEND_SCENE)
    elif pattern_type == 5:
        generator.init(0,2,100,100,6,PROJECTILE_GEND_SCENE)
    return generator


func _on_Enemy_entity_tree_entered():
    var error = connect("boss_health_updated", get_node("../Player"), "_on_Enemy_entity_boss_health_updated")
    if error:
        print("connection boss_health updated in enemy entity: error")

    var error2 = connect("boss_died", get_node("../Player"), "_on_Enemy_entity_boss_died")
    if error2:
        print("connection boss_died updated in enemy entity: error")
