extends KinematicBody2D

signal boss_health_updated(new_value, old_value)

# Declare member variables here. Examples:
# var a = 2

export var BOSS_MAX_HP = 200
export onready var BOSS_CUR_HP = 200

export var ACCELERATION = 300
export var FRICTION = 400
export var MAX_SPEED = 200
onready var playerDetectionZone = $Player_detection_zone
onready var attack_range = $attack_range
onready var enemy_sprite = $EnemySprite
export var MAX_HEALTH = 10

# For Debugging purpose only
onready var healthLabel = $Label

enum {
    IDLE,
    CHASE,
    ATTACK
}
var velocity = Vector2.ZERO

var state = IDLE
var direction = 1

func _physics_process(delta):
    $AnimationPlayer.play("Walk_Idle")
    healthLabel.text = str(MAX_HEALTH)
    match state:
        IDLE:
            #enemy_sprite.play("Idle")
            velocity = velocity.move_toward(Vector2.ZERO, FRICTION*delta)
            see_player()
        CHASE:
            var player = playerDetectionZone.player
            if player != null:
                var lienar_direction =  (player.global_position - global_position).normalized()
                velocity = velocity.move_toward(lienar_direction * MAX_SPEED, ACCELERATION * delta)
                
            if velocity.x > 0:
                enemy_sprite.flip_h = false
            if velocity.x < 0:
                enemy_sprite.flip_h = true
            see_player()
            #can_attack_player()
        ATTACK:
            velocity = velocity.move_toward(Vector2.ZERO, FRICTION*delta)
            print("attacked player")
            see_player()
            #enemy_sprite.play("Attack")
    
    velocity = move_and_slide(velocity)

func damage_boss(damage):
    if BOSS_CUR_HP < damage:
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
    queue_free()
    pass


func see_player():
    if playerDetectionZone.can_see_player():
        state = CHASE
    else :
        state = IDLE
        
func can_attack_player():
    if attack_range.can_attack_player():
        state = ATTACK
    else: 
        state = IDLE

# Player Projectile collides with boss
func _on_Area2D_area_entered(area:Area2D):
    if area.name == "bullet_area":
        area.get_parent().queue_free()
        damage_boss(5)
        

