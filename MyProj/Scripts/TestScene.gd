extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
# Called when the node enters the scene tree for the first time.
func _ready():
    if Mainmenumusic.is_playing():
        Mainmenumusic.stop()
    if not FightMusic.is_playing():
        FightMusic.play()
    pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#    pass
