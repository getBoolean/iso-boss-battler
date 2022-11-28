class_name EnemyEntity
extends KinematicBody2D

signal boss_health_updated(new_value, old_value)
signal boss_died(difference)

# Load the projectile scene/node
const PROJECTILE_SCENE = preload("res://Scenes/Projectile.tscn")

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
export var MAX_HEALTH = 10

onready var anim_player = $AnimatedSprite/AnimationPlayer
onready var state_machine = $StateMachine


# For Debugging purpose only
onready var healthLabel = $Label

var velocity = Vector2.ZERO

var direction = 1

#var distance_to_player = global_position.direction_to(playerDetectionZone.player.global_position)

func _physics_process(_delta):
    healthLabel.text = str(MAX_HEALTH)
        

func see_player():
    if playerDetectionZone.can_see_player():
        player = playerDetectionZone.player
        if player:
            return true
        return false
       
        
# Player Projectile collides with boss
func _on_Area2D_area_entered(area: Area2D):
    if area.name == "bullet_area" and area.get_parent().projectile_owner == "Player":
        area.get_parent().queue_free()
        # The boss should only take damage if they have this function.
        # Only `AttackState` has this method, so the boss is invulnerable in
        # other states.
        # We need to use methods on the current state to encapsulate state
        # transition logic
        if state_machine.state.has_method('damage_boss'):
            state_machine.state.damage_boss(5)
        
func fire():
    timer_node.start(fire_delay_rate)
    var projectile = PROJECTILE_SCENE.instance()
    get_parent().add_child(projectile)
    projectile.projectile_owner = "Enemy_entity"
    projectile.position = global_position
    projectile.velocity = player.global_position - projectile.position
    projectile.scale.x = 1.5
    projectile.scale.y = 1.5
    projectile.look_at(player.global_position)

func update_hp(new_health: int):
    emit_signal("boss_health_updated", new_health, BOSS_CUR_HP)
    BOSS_CUR_HP = new_health


func kill(difference):
    MAX_SPEED = 0
    anim_player.play("Death")
    yield(anim_player,"animation_finished")
    emit_signal("boss_died", difference)
