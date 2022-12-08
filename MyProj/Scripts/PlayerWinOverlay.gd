extends Control

var mainMenuScene = load("res://Scenes/StartMenu.tscn")

onready var hover_sfx = $hover_sound
onready var down_sfx = $down_sound
onready var up_sfx = $up_sound

func _ready():
    var os = OS.get_name()
    if (os == "Android" or os == "iOS" or os == "HTML5"):
        hide()

func _process(_delta: float):
    var root = get_tree().current_scene
    if not root:
        return
    var player = root.get_node("PlayerLayer/Player")
    if not player:
        return
    player = player as Player
    if Input.is_action_pressed("ui_cancel") and player.has_won:
        up_sfx.play()
        yield(up_sfx, "finished")
        hide()
        var error_code = get_tree().change_scene_to(mainMenuScene)
        if error_code != Global.SUCCESS_CODE:
            print("[ERROR] Could not change scene to main menu: ", error_code)

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


func _on_Player_player_won(_difference: float):
    var root = get_tree().current_scene
    var fg_layer = root.get_node("ForegroundLayer")
    var crosshair = fg_layer.get_node("Crosshair")
    if crosshair:
        crosshair.queue_free()
    show()

# SFX
# Hover
func _on_bt_main_menu_mouse_entered():
    if not down_sfx.playing:
        hover_sfx.play()
func _on_bt_exit_to_desktop_mouse_entered():
    if not down_sfx.playing:
        hover_sfx.play()
# Down
func _on_bt_main_menu_button_down():
    down_sfx.play()
func _on_bt_exit_to_desktop_button_down():
    down_sfx.play()
