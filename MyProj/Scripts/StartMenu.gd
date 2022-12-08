extends Control

export var introScene : PackedScene

export var creditsScene : PackedScene

var options_menu = preload("res://Scenes/OptionsMenu.tscn")

onready var hover_sfx = $hover_sound
onready var down_sfx = $down_sound
onready var up_sfx = $up_sound

func _ready():
    if not Mainmenumusic.is_playing():
        Mainmenumusic.play()
    if FightMusic.is_playing():
        FightMusic.stop()
    if Level2Music.is_playing():
        Level2Music.stop()
    pass

func _on_bt_new_game_button_up():
    up_sfx.play()
    yield(up_sfx, "finished")
    var error_code = get_tree().change_scene(introScene.resource_path)
    if error_code != Global.SUCCESS_CODE:
        print("[ERROR] Could not change scene to main game: ", error_code)

func _on_bt_quit_button_up():
    up_sfx.play()
    yield(up_sfx, "finished")
    print("Quitting game...")
    get_tree().quit()



func _on_bt_credits_button_up():
    up_sfx.play()
    yield(up_sfx, "finished")
    var error_code = get_tree().change_scene(creditsScene.resource_path)
    if error_code != Global.SUCCESS_CODE:
        print("[ERROR] Could not change scene to credits: ", error_code)

func _on_bt_options_button_up():
    up_sfx.play()
    yield(up_sfx, "finished")
    var error_code = get_tree().change_scene_to(options_menu)
    if error_code != Global.SUCCESS_CODE:
        print("[ERROR] Could not change scene to credits: ", error_code)

# Menu Button SFX
# For mouse hovering over button
func _on_bt_new_game_mouse_entered():
    if not down_sfx.playing:
        hover_sfx.play()
func _on_bt_options_mouse_entered():
    if not down_sfx.playing:
        hover_sfx.play()
func _on_bt_credits_mouse_entered():
    if not down_sfx.playing:
        hover_sfx.play()
func _on_bt_quit_mouse_entered():
    if not down_sfx.playing:        
        hover_sfx.play()
# For when button is clicked but not yet released
func _on_bt_new_game_button_down():
    down_sfx.play()
func _on_bt_options_button_down():
    down_sfx.play()
func _on_bt_credits_button_down():
    down_sfx.play()
func _on_bt_quit_button_down():
    down_sfx.play()
