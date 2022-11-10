extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var fight_music = $FightMusic

# Called when the node enters the scene tree for the first time.
func _ready():
    Mainmenumusic.stop()
    if not fight_music.is_playing():
        fight_music.play()
    pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#    pass
