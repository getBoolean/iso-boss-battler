extends Area2D


var player = null

func can_see_player():
    return player


func _on_Player_detection_zone_body_entered(body):
    if(body.name == "Player"):
        player = body


func _on_Player_detection_zone_body_exited(_body):
    if(_body.name == "Player"):
        player = null
