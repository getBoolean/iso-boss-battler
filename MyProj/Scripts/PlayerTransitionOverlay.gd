extends Control

var mainMenuScene = load("res://Scenes/StartMenu.tscn")
var transition = load("res://Scenes/Cutscenes/TransitionCutscene.tscn")


# Called when the node enters the scene tree for the first time.
func _ready():
    pass # Replace with function body.


func _on_bt_continue_pressed():
    hide()
    var error_code = get_tree().change_scene_to(transition)
    if error_code != Global.SUCCESS_CODE:
        print("[ERROR] Could not change scene to main menu: ", error_code)


func _on_bt_replay_level_pressed():
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

func _on_Player_boss_died(_difference):
    var root = get_tree().current_scene
    var fg_layer = root.get_node("ForegroundLayer")
    var crosshair = fg_layer.get_node("Crosshair")
    if crosshair:
        crosshair.queue_free()
    show()
