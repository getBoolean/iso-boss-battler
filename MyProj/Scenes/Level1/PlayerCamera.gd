extends Camera2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var player_node2

func _on_PlayerCamera_tree_entered():
    player_node2 = get_parent().get_node("PlayerLayer/Player")
    pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
    self.position = player_node2.position
    pass



