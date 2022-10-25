extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
export var ACCELERATION = 300
export var FRICTION = 400
export var MAX_SPEED = 200
onready var playerDetectionZone = $Player_detection_zone
onready var attack_range = $attack_range
onready var enemy_sprite = $enemy_Sprite
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
    match state:
        IDLE:
            #enemy_sprite.play("Idle")
            velocity = velocity.move_toward(Vector2.ZERO, FRICTION*delta)
            see_player()
        CHASE:
            var player = playerDetectionZone.player
            if player != null:
                var direction =  (player.global_position - global_position).normalized()
                velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)
                
            if velocity.x > 0:
                $Sprite.flip_h = false
            if velocity.x < 0:
                $Sprite.flip_h = true
            see_player()
            #can_attack_player()
        ATTACK:
            velocity = velocity.move_toward(Vector2.ZERO, FRICTION*delta)
            print("attacked player")
            see_player()
            #enemy_sprite.play("Attack")
    
    velocity = move_and_slide(velocity)


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


