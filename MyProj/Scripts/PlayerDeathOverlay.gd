extends Control

var mainMenuScene = load("res://Scenes/StartMenu.tscn")


func _ready():
    var os = OS.get_name()
    if (os == "Android" or os == "iOS" or os == "HTML5"):
        hide()


func _on_bt_respawn_button_up():
    # TODO: Reset player and level, and hide this overlay
    hide()
    var error_code = get_tree().reload_current_scene()
    if error_code != Global.SUCCESS_CODE:
        print("[ERROR] Could not reload scene: ", error_code)


func _on_bt_leave_game_button_up():
    hide()
    var error_code = get_tree().change_scene_to(mainMenuScene)
    if error_code != Global.SUCCESS_CODE:
        print("[ERROR] Could not change scene to main menu: ", error_code)


func _on_bt_exit_to_desktop_button_up():
    print("Quitting game...")
    get_tree().quit()


func _on_Player_player_died(_difference):
    var root = get_tree().current_scene
    var fg_layer = root.get_node("Foreground Layer")
    fg_layer.get_node("Crosshair").queue_free()
    show()
    pass # Replace with function body.


func _on_Player_you_won(_difference):
    var root = get_tree().current_scene
    var fg_layer = root.get_node("Foreground Layer")
    var crosshair = fg_layer.get_node("Crosshair")
    if crosshair:
        crosshair.queue_free()
    show()
