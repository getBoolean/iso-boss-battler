extends Control

var level2 = load("res://Scenes/Level2/Level2.tscn")


func _input(event):
    if event is InputEventKey or event is InputEventMouseButton:
        if event.pressed:
            _continue()

func _continue():
    var error_code = get_tree().change_scene_to(level2)
    if error_code != Global.SUCCESS_CODE:
        print("[ERROR] Could not change scene to level 2: ", error_code)
