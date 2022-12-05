class_name AOEAttack
extends KinematicBody2D

onready var sprite: AnimatedSprite = $AnimatedSprite
onready var hitbox: CollisionPolygon2D = $bullet_area/CollisionShape2D
onready var collision: CollisionPolygon2D = $CollisionShape2D
onready var lower_delay_timer: Timer = $LowerDelayTimer
onready var state: int = 0

func _ready():
    sprite.play("rising")
    yield(sprite, "animation_finished")
    lower_delay_timer.start()
    state = 1


func _on_Timer_timeout():
    sprite.play("lowering")
    yield(sprite, "animation_finished")
    hitbox.disabled = true
    queue_free()
