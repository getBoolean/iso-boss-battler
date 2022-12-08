extends Control

var mainMenuScene = load("res://Scenes/StartMenu.tscn")
var transition = load("res://Scenes/Cutscenes/TransitionCutscene.tscn")

onready var hover_sfx = $hover_sound
onready var down_sfx = $down_sound
onready var up_sfx = $up_sound


# Called when the node enters the scene tree for the first time.
func _ready():
    pass # Replace with function body.


func _on_bt_continue_button_up():
    up_sfx.play()
    yield(up_sfx, "finished")
    hide()
    var error_code = get_tree().change_scene_to(transition)
    if error_code != Global.SUCCESS_CODE:
        print("[ERROR] Could not change scene to main menu: ", error_code)

func _on_bt_replay_level_button_up():
    up_sfx.play()
    yield(up_sfx, "finished")
    hide()
    var error_code = get_tree().reload_current_scene()
    if error_code != Global.SUCCESS_CODE:
        print("[ERROR] Could not reload scene: ", error_code)

func _on_bt_leave_game_button_up():
    up_sfx.play()
    yield(up_sfx, "finished")
    hide()
    var error_code = get_tree().change_scene_to(mainMenuScene)
    if error_code != Global.SUCCESS_CODE:
        print("[ERROR] Could not change scene to main menu: ", error_code)


func _on_bt_exit_to_desktop_button_up():
    up_sfx.play()
    yield(up_sfx, "finished")
    print("Quitting game...")
    get_tree().quit()

func _on_Player_boss_died(_difference):
    Global.player_died_level1 = false
    var root = get_tree().current_scene
    var fg_layer = root.get_node("ForegroundLayer")
    var crosshair = fg_layer.get_node("Crosshair")
    if crosshair:
        crosshair.queue_free()
    show()
    

# Button SFX
# Hover
func _on_bt_continue_mouse_entered():
    if not down_sfx.playing:
        hover_sfx.play()
func _on_bt_replay_level_mouse_entered():
    if not down_sfx.playing:
        hover_sfx.play()
func _on_bt_main_menu_mouse_entered():
    if not down_sfx.playing:
        hover_sfx.play()
func _on_bt_exit_to_desktop_mouse_entered():
    if not down_sfx.playing:
        hover_sfx.play()
# Down
func _on_bt_continue_button_down():
    down_sfx.play()
func _on_bt_replay_level_button_down():
    down_sfx.play()
func _on_bt_main_menu_button_down():
    down_sfx.play()
func _on_bt_exit_to_desktop_button_down():
    down_sfx.play()






