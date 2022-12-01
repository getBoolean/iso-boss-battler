extends Node2D

onready var queue = []


onready var queue_timer_delay = 1
onready var rng = RandomNumberGenerator.new()

func _ready():
    for i in range(12):
        rng.randomize()
        var value = rng.randi_range(1,4)
        queue.append(value)
        print(value)
    

func fire_pattern():
    var ret_val = queue.pop_front()
    rng.randomize()
    queue.append(rng.randi_range(1,3))
    print("new queue:")
    for i in range(12):
        print(queue[i])
    return ret_val
        


