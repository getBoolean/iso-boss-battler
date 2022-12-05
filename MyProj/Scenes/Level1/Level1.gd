extends Node2D

onready var blocker = $PlayerLayer/Foliage/EntranceBlock/invisblocker
onready var pillar1 = $PlayerLayer/Foliage/EntranceBlock/Pillar1
onready var pillar2 = $PlayerLayer/Foliage/EntranceBlock/Pillar2
onready var fall_sfx = $PlayerLayer/Foliage/EntranceBlock/fall_sound
onready var fall_timer = $PlayerLayer/Foliage/EntranceBlock/fall_timer
onready var cam1 = $PlayerCamera

onready var player = $PlayerLayer/Player
onready var player_respawn_loc = $PlayerLayer/PlayerRespawnPos

var BOSSROOM_ENTRANCE_HEIGHT = -1889

var has_entered_bossroom = false


func _on_Level1_ready():
# if player has died at least once on level1, set the player's
# location to the respawn location instead of the default start location
    if Global.player_died_level1 == true:
        player.position = player_respawn_loc.position
    

func _process(_delta):
    if player.position.y <= BOSSROOM_ENTRANCE_HEIGHT && has_entered_bossroom == false:
        trigger_bossroom_trap()

# triggers the pillars falling to trap player in bossroom
func trigger_bossroom_trap():
    has_entered_bossroom = true
    pillar1.position = Vector2(-33, -1872)
    pillar1.rotation_degrees = 90
    fall_sfx.play()
    fall_timer.start()
    
# a timer to stagger the falling of the two pillars
func _on_fall_timer_timeout():
    pillar2.position = Vector2(40, -1872)
    pillar2.rotation_degrees = -90
    fall_sfx.play()
    
    



