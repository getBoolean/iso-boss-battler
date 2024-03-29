extends Control
var mainMenuScene = load("res://Scenes/StartMenu.tscn")
onready var root = get_tree().current_scene
onready var fg_layer = root.get_node("ForegroundLayer")

onready var hover_sfx = $hover_sound
onready var down_sfx = $down_sound
onready var up_sfx = $up_sound

func _input(event):
    var root = get_tree().current_scene
    if not root:
        return
    var player = root.get_node("PlayerLayer/Player")
    if not player:
        return
    player = player as Player
    if player.has_won || not player.is_Alive:
        return
        
    if event.is_action_pressed("pause_game") && get_tree().paused:
        hide()
        Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
        var crosshair = fg_layer.get_node("Crosshair")
        if crosshair:
            crosshair.visible = true
        get_tree().paused = false
    
    elif(event.is_action_pressed("pause_game") && !get_tree().paused):
        show()
        # Enabble custom mouse pointer and enable system pointer
        var crosshair = fg_layer.get_node("Crosshair")
        if crosshair:
            crosshair.visible = false
        Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

        # unpause the game tree
        get_tree().paused = !get_tree().paused


func _on_bt_exit_to_desktop_button_up():
    up_sfx.play()
    yield(up_sfx, "finished")
    get_tree().quit()


func _on_bt_quit_main_to_menu_button_up():
    Global.player_died_level1 = false
    up_sfx.play()
    yield(up_sfx, "finished")
    hide()
    get_tree().paused = false
    Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
    fg_layer.get_node("Crosshair").visible = true 
    var error_code = get_tree().change_scene_to(mainMenuScene)
    if error_code != Global.SUCCESS_CODE:
        print("[ERROR] Could not change scene to main menu: ", error_code)


func _on_bt_resume_game_button_up():
    up_sfx.play()
    yield(up_sfx, "finished")
    hide()
    Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
    fg_layer.get_node("Crosshair").visible = true
    get_tree().paused = false

func _on_bt_options_button_up():
    up_sfx.play()
    yield(up_sfx, "finished")
    $OptionsMenu.show()

func _on_Player_paused():
    show()
    # Disable custom mouse pointer and enable system pointer
    fg_layer.get_node("Crosshair").visible = false
    Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

    # Pause the game tree
    get_tree().paused = !get_tree().paused
    
# SFX Down
func _on_bt_resume_game_button_down():
    down_sfx.play()
func _on_bt_options_button_down():
    down_sfx.play()
func _on_bt_quit_main_to_menu_button_down():
    down_sfx.play()
func _on_bt_exit_to_desktop_button_down():
    down_sfx.play()
# Hover
func _on_bt_resume_game_mouse_entered():
    if not down_sfx.playing:
        hover_sfx.play()
func _on_bt_options_mouse_entered():
    if not down_sfx.playing:
        hover_sfx.play()
func _on_bt_quit_main_to_menu_mouse_entered():
    if not down_sfx.playing:
        hover_sfx.play()
func _on_bt_exit_to_desktop_mouse_entered():
    if not down_sfx.playing:    
        hover_sfx.play()






