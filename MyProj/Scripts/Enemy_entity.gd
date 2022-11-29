class_name EnemyEntity
extends KinematicBody2D

signal boss_health_updated(new_value, old_value)
signal boss_died(difference)

# Load the projectile scene/node
const PROJECTILE_SCENE = preload("res://Scenes/Projectile.tscn")

# Load Projectile generator scene
const generator_scene = preload("res://Scenes/projectile_spawner.tscn")

#time for projectile delay
onready var timer_node = $fire_delay_timer
export var fire_delay_rate = 0.4

#Boss Health Values
export var BOSS_MAX_HP = 200
export onready var BOSS_CUR_HP = 200

var player = null

#values for speed of boss
export var ACCELERATION = 300
export var FRICTION = 400
export var MAX_SPEED = 125
#Object references to boss attributes
onready var playerDetectionZone = $Player_detection_zone
onready var enemy_sprite = $AnimatedSprite
onready var PHASE = 1
onready var phase_changed = 0

onready var anim_player = $AnimatedSprite/AnimationPlayer

var velocity = Vector2.ZERO

var direction = 1


func see_player():
    if playerDetectionZone.can_see_player():
        player = playerDetectionZone.player
        if player:
            return true
        return false

        
func fire(speed: float, damage: float = 5, scale_x: float = 1.5, scale_y: float = 1.5):
    var projectile = PROJECTILE_SCENE.instance()
    get_parent().add_child(projectile)
    projectile.projectile_owner = "Enemy_entity"
    projectile.position = global_position
    projectile.velocity = player.global_position - projectile.position
    projectile.scale.x = scale_x
    projectile.scale.y = scale_y
    if (PHASE == 2):
        damage = damage * 1.2
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
    anim_player.play("Death")
    yield(anim_player,"animation_finished")
    emit_signal("boss_died", difference)
    
