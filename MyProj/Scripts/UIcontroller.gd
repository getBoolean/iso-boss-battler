extends Control

onready var whole_bar = get_node("VBoxContainer/TopBar/BossInfo/BossBar")
onready var boss_hpbar = get_node("VBoxContainer/TopBar/BossInfo/BossBar/Boss_HPbar")
onready var player_hpbar = get_node("VBoxContainer/BottomBar/PlayerBars/Player_HPbar")
onready var player_mpbar = get_node("VBoxContainer/BottomBar/PlayerBars/Player_MPbar") 

# Called when the node enters the scene tree for the first time.
func _ready():
    pass # Replace with function body.

func _on_Player_player_health_updated(new_hp, _old_hp):
    player_hpbar.set_value(new_hp)

func _on_Player_player_mp_updated(new_mp, _old_mp):
    player_mpbar.set_value(new_mp)
    
func _on_Player_not_enough_mp():
    # flash mp_bar
    pass

func _on_Player_hit_boss(new_hp, _old_hp):
    boss_hpbar.set_value(new_hp)    
    
func _on_ActivateState_show_boss_hp():
    whole_bar.visible = true
    
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
    pass
    # Update HP/MP Values every frame
    #set boss_hpbarnode.Value = (bossnode.BOSS_CUR_HP) / bossnode.BOSS_MAX_HP)
    









