class_name SpikeAttack
extends Attack

onready var sprite: AnimatedSprite = $AnimatedSprite
onready var hitbox: CollisionPolygon2D = $damage_area/CollisionShape2D
onready var lower_delay_timer: Timer = $LowerDelayTimer
onready var state: int = 0

func _ready():
    sprite.play("rising")
    yield(sprite, "animation_finished")
    sprite.play("lowering")
    yield(sprite, "animation_finished")
    queue_free()
