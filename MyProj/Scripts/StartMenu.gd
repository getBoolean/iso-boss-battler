extends Control

export var mainGameScene : PackedScene

export var creditsScene : PackedScene

func _on_bt_new_game_button_up():
    var error_code = get_tree().change_scene(mainGameScene.resource_path)
    if error_code != Global.SUCCESS_CODE:
        print("[ERROR] Could not change scene to main game: ", error_code)

func _on_bt_quit_button_up():
    print("Quitting game...")
    get_tree().quit()


func _on_bt_credits_button_up():
    var error_code = get_tree().change_scene(creditsScene.resource_path)
    if error_code != Global.SUCCESS_CODE:
        print("[ERROR] Could not change scene to credits: ", error_code)
