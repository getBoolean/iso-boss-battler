extends Node2D

export var mainGameScene : PackedScene

func _on_bt_new_game_button_up():
    var error_code = get_tree().change_scene(mainGameScene.resource_path)
    if error_code != Global.SUCCESS_CODE:
        print("ERROR: ", error_code)
    
    Global.SUCCESS_CODE = 0


func _on_bt_quit_button_up():
    get_tree().quit()
