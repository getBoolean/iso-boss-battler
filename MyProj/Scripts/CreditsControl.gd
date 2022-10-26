extends Node2D

onready var creditsFile = 'res://Assets/credits.txt'

const SECTION_TIME := 0.5
const LINE_TIME := 0.2
const BASE_SPEED := 100
const SPEED_UP_MULTIPLIER := 10.0
const TITLE_COLOR := Color.blueviolet

var scroll_speed := BASE_SPEED
var speed_up := false

onready var line := $CreditsContainer/Line
var started := false
var finished := false

var section
var section_next := true
var section_timer := 0.0
var line_timer := 0.0
var curr_line := 0
var lines := []

var credits = []

func _ready():
    load_file(creditsFile)

# Open Credits file and read it line by line
# While reading create 2D Array of lines => [[Role,line1,line2] , [Role,line3,line4]]
func load_file(file):
    var f = File.new()
    f.open(file,File.READ)
    while not f.eof_reached(): 
        var currline = f.get_line()
        if currline.length() == 0:
            credits.append([])
        else:
            credits[credits.size()-1].append(currline)
    f.close()
    return

func _process(delta):
    var scroll_speed = BASE_SPEED * delta
    
    if section_next:
        section_timer += delta * SPEED_UP_MULTIPLIER if speed_up else delta
        if section_timer >= SECTION_TIME:
            section_timer -= SECTION_TIME
            
            if credits.size() > 0:
                started = true
                section = credits.pop_front()
                curr_line = 0
                add_line()
    
    else:
        line_timer += delta * SPEED_UP_MULTIPLIER if speed_up else delta
        if line_timer >= LINE_TIME:
            line_timer -= LINE_TIME
            add_line()
    
    if speed_up:
        scroll_speed *= SPEED_UP_MULTIPLIER
    
    if lines.size() > 0:
        for l in lines:
            l.rect_position.y -= scroll_speed
            if l.rect_position.y < -l.get_line_height():
                lines.erase(l)
                l.queue_free()
    elif started:
        finish()


func finish():
    if not finished:
        finished = true
        get_tree().change_scene("res://Scenes/StartMenu.tscn")
        # NOTE: This is called when the credits finish
        # - Hook up your code to return to the relevant scene here, eg...
        #get_tree().change_scene("res://scenes/MainMenu.tscn")


func add_line():
    var new_line = line.duplicate()
    new_line.text = section.pop_front()
    lines.append(new_line)
    if curr_line == 0:
        new_line.add_color_override("font_color", TITLE_COLOR)
    $CreditsContainer.add_child(new_line)
    
    if section.size() > 0:
        curr_line += 1
        section_next = false
    else:
        section_next = true


func _unhandled_input(event):
    if event.is_action_pressed("ui_cancel"):
        finish()
    if event.is_action_pressed("ui_down") and !event.is_echo():
        speed_up = true
    if event.is_action_released("ui_down") and !event.is_echo():
        speed_up = false
