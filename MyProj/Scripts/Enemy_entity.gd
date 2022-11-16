extends KinematicBody2D

signal boss_health_updated(new_value, old_value)
signal boss_died(difference)

# Load the projectile scene/node
const PROJECTILE_SCENE = preload("res://Scenes/Projectile.tscn")

#time for projectile delay
onready var timer_node = $fire_delay_timer
export var fire_delay_rate = 0.4

#Boss Health Values
export var BOSS_MAX_HP = 10
export onready var BOSS_CUR_HP = 10

var player = null

#values for speed of boss
export var ACCELERATION = 300
export var FRICTION = 400
export var MAX_SPEED = 125
#Object references to boss attributes
onready var playerDetectionZone = $Player_detection_zone
onready var attack_range = $attack_range
onready var enemy_sprite = $AnimatedSprite
onready var PHASE = 1
onready var phase_changed = 0
export var MAX_HEALTH = 10

onready var anim_player = $AnimatedSprite/AnimationPlayer


# For Debugging purpose only
onready var healthLabel = $Label


#states for boss
enum {
    NUETRAL,
    ACTIVATE,
    CHASE,
    ATTACKING,
    DEAD,
    PHASE_CHANGE
}
var velocity = Vector2.ZERO

var state = NUETRAL
var direction = 1
#var distance_to_player = global_position.direction_to(playerDetectionZone.player.global_position)

func _physics_process(delta):
    healthLabel.text = str(MAX_HEALTH)
    match state:
        NUETRAL:
            
            anim_player.play("Spawn")
            anim_player.stop(false)
            see_player()
        ACTIVATE:
            anim_player.play("Spawn")
            yield(anim_player,"animation_finished")
            state = CHASE
        CHASE:
            
            if PHASE == 1:
                anim_player.play("Idle")
            elif PHASE == 2:
                anim_player.play("Idle_Phase_2")
            
            player = playerDetectionZone.player
            
            if player != null:
                var linear_direction =  (player.global_position - global_position).normalized()
                velocity = velocity.move_toward(linear_direction * MAX_SPEED, ACCELERATION * delta)
                if timer_node.is_stopped():
                    fire()
                
            if velocity.x > 0:
                enemy_sprite.flip_h = false
            if velocity.x < 0:
                enemy_sprite.flip_h = true
            
            if BOSS_CUR_HP <= .5 * BOSS_MAX_HP and phase_changed == 0:
                phase_changed = 1
                state = PHASE_CHANGE
            velocity = move_and_slide(velocity)
        DEAD:
            MAX_SPEED = 0
        PHASE_CHANGE:
            MAX_SPEED = 0
            anim_player.play("Phase_Change")
            yield(anim_player,"animation_finished")
            MAX_SPEED = 125
            PHASE = 2
            state = CHASE
    
    #velocity = move_and_slide(velocity)

    

func damage_boss(damage):
    if BOSS_CUR_HP <= damage:
        var difference = damage - BOSS_CUR_HP
        emit_signal("boss_health_updated", 0, BOSS_CUR_HP)
        BOSS_CUR_HP = 0
        kill_boss(difference)
    else:
        var new_hp = BOSS_CUR_HP - damage
        emit_signal("boss_health_updated", new_hp, BOSS_CUR_HP)
        # play damage animation        
        BOSS_CUR_HP = new_hp
        
        
# kill_boss():
# animates the boss's death, calls the win screen
# difference not used, but potentially useful in future
func kill_boss(_difference):
    emit_signal("boss_died", _difference)
    anim_player.play("Death")
    state = DEAD
    #queue_free()
    pass


func see_player():
    if playerDetectionZone.can_see_player():
        player = playerDetectionZone.player
        if state == NUETRAL:
            state = ACTIVATE
       
        
# Player Projectile collides with boss
func _on_Area2D_area_entered(area:Area2D):
    if area.name == "bullet_area" and area.get_parent().projectile_owner == "Player":
        area.get_parent().queue_free()
        damage_boss(5)
        
func fire():
    timer_node.start(fire_delay_rate)
    var projectile = PROJECTILE_SCENE.instance()
    get_parent().add_child(projectile)
    projectile.projectile_owner = "Enemy_entity"
    projectile.position = global_position
    projectile.velocity = player.global_position - projectile.position
    projectile.scale.x = 1.5
    projectile.scale.y = 1.5
