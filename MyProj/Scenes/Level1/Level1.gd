extends Node2D

onready var blocker = $PlayerLayer/Foliage/EntranceBlock/invisblocker
onready var pillar1 = $PlayerLayer/Foliage/EntranceBlock/Pillar1
onready var pillar2 = $PlayerLayer/Foliage/EntranceBlock/Pillar2
onready var fall_sfx = $PlayerLayer/Foliage/EntranceBlock/fall_sound
onready var fall_timer = $PlayerLayer/Foliage/EntranceBlock/fall_timer
onready var cam1 = $PlayerCamera

onready var player = $PlayerLayer/Player

var BOSSROOM_ENTRANCE_HEIGHT = -1889

var has_entered_bossroom = false

# Called when the node enters the scene tree for the first time.
func _ready():
    pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
    if player.position.y <= BOSSROOM_ENTRANCE_HEIGHT && has_entered_bossroom == false:
        trigger_bossroom_trap()

func trigger_bossroom_trap():
    has_entered_bossroom = true
    pillar1.position = Vector2(-33, -1872)
    pillar1.rotation_degrees = 90
    fall_sfx.play()
    fall_timer.start()
    


func _on_fall_timer_timeout():
    pillar2.position = Vector2(40, -1872)
    pillar2.rotation_degrees = -90
    fall_sfx.play()
    cam1.zoom.x = 1.2
    cam1.zoom.y = 1.2
    
    
