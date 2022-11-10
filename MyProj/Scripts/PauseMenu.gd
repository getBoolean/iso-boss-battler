extends Control
var mainMenuScene = load("res://Scenes/StartMenu.tscn")
onready var root = get_tree().current_scene
onready var fg_layer = root.get_node("Foreground Layer")

func _input(event):
    if event.is_action_pressed("pause_game") && get_tree().paused:
        hide()
        Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
        fg_layer.get_node("Crosshair").visible = true
        get_tree().paused = false
    
    elif(event.is_action_pressed("pause_game") && !get_tree().paused):
        show()
        # Enabble custom mouse pointer and enable system pointer
        fg_layer.get_node("Crosshair").visible = false
        Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

        # unpause the game tree
        get_tree().paused = !get_tree().paused


func _on_bt_exit_to_desktop_button_up():
    get_tree().quit()


func _on_bt_quit_main_to_menu_button_up():
    hide()
    get_tree().paused = false
    Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
    fg_layer.get_node("Crosshair").visible = true 
    var error_code = get_tree().change_scene_to(mainMenuScene)
    if error_code != Global.SUCCESS_CODE:
        print("[ERROR] Could not change scene to main menu: ", error_code)


func _on_bt_resume_game_button_up():
    hide()
    Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
    fg_layer.get_node("Crosshair").visible = true
    get_tree().paused = false


func _on_Player_paused():
    show()
    # Disable custom mouse pointer and enable system pointer
    fg_layer.get_node("Crosshair").visible = false
    Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

    # Pause the game tree
    get_tree().paused = !get_tree().paused
    