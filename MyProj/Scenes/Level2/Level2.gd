extends Node2D

onready var player = $PlayerLayer/Player
onready var dooropen   = $BackgroundLayer/boss_room_door/open_door
onready var doorclosed = $BackgroundLayer/boss_room_door/closed_door

var BOSSROOM_ENTRANCE_HEIGHT = -347

var has_entered_bossroom = false


func _process(_delta):
    if player.position.y <= BOSSROOM_ENTRANCE_HEIGHT && has_entered_bossroom == false:
        trigger_bossroom_trap()

func trigger_bossroom_trap():
    has_entered_bossroom = true
    dooropen.hide()
    doorclosed.show()
