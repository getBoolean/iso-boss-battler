class_name AttackQueue
extends Node2D

onready var queue = []


onready var queue_timer_delay = 1
onready var rng = RandomNumberGenerator.new()

func _ready():
    for _i in range(5):
        rng.randomize()
        var value = rng.randi_range(1,3)
        queue.append(value)
    

func fire_pattern():
    var ret_val = queue.pop_front()
    prioritize()
    return ret_val

func prioritize():
    var high_threat_count = 0
    for i in queue:
        if i == 4 or i == 5:
            high_threat_count += 1
    
    if high_threat_count == 0 :
        rng.randomize()
        queue.append(rng.randi_range(4,5))
    else:
        rng.randomize()
        queue.append(rng.randi_range(1,3))
