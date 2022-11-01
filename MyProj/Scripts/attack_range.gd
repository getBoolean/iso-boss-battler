extends Area2D


var player = null


func can_attack_player():
    return player



func _on_attack_range_area_entered(_area):
    player != null


func _on_attack_range_area_exited(_area):
    player = null
