extends Control

onready var player_node = get_parent().get_parent()
var boss_node = null

var boss_hpbar = null
onready var player_hpbar = get_node("VBoxContainer/BottomBar/PlayerBars/Player_HPbar")
onready var player_mpbar = get_node("VBoxContainer/BottomBar/PlayerBars/Player_MPbar") 

# Called when the node enters the scene tree for the first time.
func _ready():
    player_hpbar.set_value(player_node.PLAYER_MAX_HP)
    player_mpbar.set_value(player_node.PLAYER_MAX_MP)
    # get boss node
        
    # get boss_hpbar node
    
    # get player_hpbar node
    # get player_mpbar node
    pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    #set boss_hpbarnode.Value = (bossnode.BOSS_CUR_HP) / bossnode.BOSS_MAX_HP)
    player_hpbar.set_value(player_node.PLAYER_CUR_HP)
    player_mpbar.set_value(player_node.PLAYER_CUR_MP)
    
