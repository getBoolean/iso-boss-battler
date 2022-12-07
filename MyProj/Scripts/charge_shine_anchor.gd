extends Node2D

var y_offset = 16.4
onready var player = get_parent().get_node("Player")
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
    self.look_at(get_global_mouse_position())
    self.position.x = player.position.x
    self.position.y = player.position.y - y_offset
