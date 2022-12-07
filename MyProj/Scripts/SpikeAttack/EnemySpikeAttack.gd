class_name SpikeAttack
extends Attack

onready var sprite: AnimatedSprite = $AnimatedSprite
onready var hitbox: CollisionShape2D = $damage_area/CollisionShape2D
onready var state: int = 0

func _ready():
    sprite.play("rising")
    yield(sprite, "animation_finished")
    sprite.play("lowering")
    yield(sprite, "animation_finished")
    queue_free()
