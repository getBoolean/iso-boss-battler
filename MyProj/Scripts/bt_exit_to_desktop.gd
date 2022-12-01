extends Button

func _ready():
    var os = OS.get_name()
    if (os == "Android" or os == "iOS" or os == "HTML5"):
        hide()
