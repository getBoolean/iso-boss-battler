extends Camera2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var player_node

func _on_PlayerCamera_tree_entered():
    player_node = get_parent().get_node("PlayerLayer/Player")
    pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
    self.position = player_node.position
    pass



