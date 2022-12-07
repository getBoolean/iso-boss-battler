extends Control

var main_menu = load("res://Scenes/StartMenu.tscn")
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var master_slider = $MarginContainer/VBoxContainer/MarginContainer/VBoxContainer/MasterVolContainer/MasterSlider
onready var music_slider = $MarginContainer/VBoxContainer/MarginContainer/VBoxContainer/MusicVolContainer/MusicSlider
onready var sfx_slider = $MarginContainer/VBoxContainer/MarginContainer/VBoxContainer/SFXVolContainer/SFXSlider

onready var hover_sfx = $hover_sound
onready var down_sfx = $down_sound
onready var up_sfx = $up_sound

# Called when the node enters the scene tree for the first time.
func _ready():
    master_slider.set_value(AudioServer.get_bus_volume_db(Global.AudioTracks.MASTER))
    music_slider.set_value(AudioServer.get_bus_volume_db(Global.AudioTracks.MUSIC))
    sfx_slider.set_value(AudioServer.get_bus_volume_db(Global.AudioTracks.SFX))
    pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#    pass


func _on_BackButton_button_up():
    var scene_name = get_tree().current_scene.name
    if scene_name == "OptionsMenu":
        up_sfx.play()
        yield(up_sfx, "finished")
        var error_code = get_tree().change_scene_to(main_menu)
        if error_code != Global.SUCCESS_CODE:
            print("[ERROR] Could not change scene to main game: ", error_code)
    else:
        up_sfx.play()
        yield(up_sfx, "finished")
        self.hide()
    


func _on_MasterSlider_value_changed(volume):
    Global.update_volume(Global.AudioTracks.MASTER, volume)


func _on_MusicSlider_value_changed(volume):
    Global.update_volume(Global.AudioTracks.MUSIC, volume)
    pass # Replace with function body.


func _on_SFXSlider_value_changed(volume):
    Global.update_volume(Global.AudioTracks.SFX, volume)
    pass # Replace with function body.

# Menu SFX
# Down
func _on_BackButton_button_down():
    down_sfx.play()
func _on_MasterSlider_drag_started():
    down_sfx.play()
func _on_MusicSlider_drag_started():
    down_sfx.play()
func _on_SFXSlider_drag_started():
    down_sfx.play()
# Up
func _on_MasterSlider_drag_ended(_value_changed):
    up_sfx.play()
func _on_MusicSlider_drag_ended(_value_changed):
    up_sfx.play()
func _on_SFXSlider_drag_ended(_value_changed):
    up_sfx.play()
# Hover
func _on_BackButton_mouse_entered():
    if not down_sfx.playing:
        hover_sfx.play()
func _on_MasterSlider_mouse_entered():
    if not down_sfx.playing:
        hover_sfx.play()
func _on_MusicSlider_mouse_entered():
    if not down_sfx.playing:
        hover_sfx.play()
func _on_SFXSlider_mouse_entered():
    if not down_sfx.playing:
        hover_sfx.play()
