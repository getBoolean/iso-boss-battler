extends Control

export var mainGameScene : PackedScene

enum STATE {
    ONE,
    TWO,
    THREE,
    LAST
}

var state = STATE.ONE


func _input(event):
    if event is InputEventKey:
        if event.pressed:
            _continue()
            
func _continue():
    if (state == STATE.ONE):
        state = STATE.TWO
        $TextBoxBackground/Dialog1.hide()
        $TextBoxBackground/Dialog2.show()
    elif (state == STATE.TWO):
        state = STATE.THREE
        $Background1.hide()
        $Background2.show()
        $TextBoxBackground/Dialog2.hide()
        $TextBoxBackground/Dialog3.show()
    elif (state == STATE.THREE):
        state = STATE.LAST
        $TextBoxBackground/Dialog3.hide()
        $TextBoxBackground/Dialog4.show()
    elif (state == STATE.LAST):
        var error_code = get_tree().change_scene(mainGameScene.resource_path)
        if error_code != Global.SUCCESS_CODE:
            print("[ERROR] Could not change scene to main game: ", error_code)
