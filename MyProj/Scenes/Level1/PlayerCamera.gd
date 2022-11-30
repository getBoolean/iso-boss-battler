extends Camera2D

onready var player_node

# get reference to player node when put into scene scene starts
func _on_PlayerCamera_tree_entered():
    player_node = get_parent().get_node("PlayerLayer/Player")

# set camera position to player position
func _process(_delta):
    self.position = player_node.position



