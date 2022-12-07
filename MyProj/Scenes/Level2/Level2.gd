extends Node2D

onready var player = $PlayerLayer/Player
onready var dooropen   = $PlayerLayer/Wall/Gate/open_door
onready var doorclosed = $PlayerLayer/Wall/Gate/closed_door
onready var collision: CollisionShape2D = $PlayerLayer/Wall/Gate/StaticBody2D/door

onready var close_sfx = $PlayerLayer/Wall/Gate/door_shut

var BOSSROOM_ENTRANCE_HEIGHT = -347

var has_entered_bossroom = false


func _process(_delta):
    if player.position.y <= BOSSROOM_ENTRANCE_HEIGHT && has_entered_bossroom == false:
        trigger_bossroom_trap()

func trigger_bossroom_trap():
    has_entered_bossroom = true
    dooropen.hide()
    doorclosed.show()
    close_sfx.play()
    collision.disabled = false
