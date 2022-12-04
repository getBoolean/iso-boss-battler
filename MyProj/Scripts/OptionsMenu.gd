extends Control

var main_menu = load("res://Scenes/StartMenu.tscn")
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var master_slider = $MarginContainer/VBoxContainer/MarginContainer/VBoxContainer/MasterVolContainer/MasterSlider
onready var music_slider = $MarginContainer/VBoxContainer/MarginContainer/VBoxContainer/MusicVolContainer/MusicSlider
onready var sfx_slider = $MarginContainer/VBoxContainer/MarginContainer/VBoxContainer/SFXVolContainer/SFXSlider

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
    var error_code = get_tree().change_scene_to(main_menu)
    if error_code != Global.SUCCESS_CODE:
        print("[ERROR] Could not change scene to main game: ", error_code)
    pass # Replace with function body.


func _on_MasterSlider_value_changed(volume):
    Global.update_volume(Global.AudioTracks.MASTER, volume)


func _on_MusicSlider_value_changed(volume):
    Global.update_volume(Global.AudioTracks.MUSIC, volume)
    pass # Replace with function body.


func _on_SFXSlider_value_changed(volume):
    Global.update_volume(Global.AudioTracks.SFX, volume)
    pass # Replace with function body.
