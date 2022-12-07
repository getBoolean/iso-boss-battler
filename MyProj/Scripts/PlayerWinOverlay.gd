extends Control

var mainMenuScene = load("res://Scenes/StartMenu.tscn")


func _ready():
    var os = OS.get_name()
    if (os == "Android" or os == "iOS" or os == "HTML5"):
        hide()


func _on_bt_leave_game_button_up():
    hide()
    var error_code = get_tree().change_scene_to(mainMenuScene)
    if error_code != Global.SUCCESS_CODE:
        print("[ERROR] Could not change scene to main menu: ", error_code)


func _on_bt_exit_to_desktop_button_up():
    print("Quitting game...")
    get_tree().quit()


func _on_Player_player_won(_difference: float):
    var root = get_tree().current_scene
    var fg_layer = root.get_node("ForegroundLayer")
    var crosshair = fg_layer.get_node("Crosshair")
    if crosshair:
        crosshair.queue_free()
    show()
