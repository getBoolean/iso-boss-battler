extends Area2D


var player = null


func can_attack_player():
    return player



func _on_attack_range_area_entered(area):
    player != null


func _on_attack_range_area_exited(area):
    player = null
