extends Node2D

export var mainGameScene : PackedScene



func _on_bt_new_game_button_up():
    get_tree().change_scene(mainGameScene.resource_path)


func _on_bt_quit_button_up():
    get_tree().quit()
