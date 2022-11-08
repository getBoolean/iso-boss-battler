extends RayCast2D

onready var line = $Line2D
onready var end = $end


const OFFSET = 15

var max_distance = 100

func _ready():
    cast_to = Vector2(0,max_distance)

func _physics_process(_delta):
    if is_colliding():
        var coll_point = to_local(get_collision_point())
        line.points[1].y = coll_point.y
        end.position.y = coll_point.y - OFFSET


    
