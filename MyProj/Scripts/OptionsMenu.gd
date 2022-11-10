extends Control

var main_menu = load("res://Scenes/StartMenu.tscn")
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
    pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#    pass


func _on_BackButton_button_up():
    var error_code = get_tree().change_scene_to(main_menu)
    if error_code != Global.SUCCESS_CODE:
        print("[ERROR] Could not change scene to main game: ", error_code)
    pass # Replace with function body.
