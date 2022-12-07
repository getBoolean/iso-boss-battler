extends Control

var mainMenuScene = load("res://Scenes/StartMenu.tscn")

onready var hover_sfx = $hover_sound
onready var down_sfx = $down_sound
onready var up_sfx = $up_sound

func _ready():
    var os = OS.get_name()
    if (os == "Android" or os == "iOS" or os == "HTML5"):
        hide()


func _on_bt_respawn_button_up():
    # TODO: Reset player and level, and hide this overlay
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


func _on_Player_player_died(_difference):
    var root = get_tree().current_scene
    var fg_layer = root.get_node("ForegroundLayer")
    fg_layer.get_node("Crosshair").queue_free()
    show()

# SFX
# Hover
func _on_bt_respawn_mouse_entered():
    if not down_sfx.playing:
        hover_sfx.play()
func _on_bt_leave_game_mouse_entered():
    if not down_sfx.playing:
        hover_sfx.play()
func _on_bt_exit_to_desktop_mouse_entered():
    if not down_sfx.playing:
        hover_sfx.play()
# Down
func _on_bt_respawn_button_down():
    down_sfx.play()
func _on_bt_leave_game_button_down():
    down_sfx.play()
func _on_bt_exit_to_desktop_button_down():
    down_sfx.play()
