extends Control

export var mainMenuScene : PackedScene

func _ready():
    pass


func _on_bt_respawn_button_up():
    # TODO: Reset player and level, and hide this overlay
    pass


func _on_bt_leave_game_button_up():
    var error_code = get_tree().change_scene(mainMenuScene.resource_path)
    if error_code != Global.SUCCESS_CODE:
        print("[ERROR] Could not change scene to main menu: ", error_code)


func _on_bt_exit_to_desktop_button_up():
    print("Quitting game...")
    get_tree().quit()
