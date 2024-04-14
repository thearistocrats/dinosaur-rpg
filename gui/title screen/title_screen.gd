extends Node2D
var screen_size:Vector2

func _ready():
	screen_size = get_viewport_rect().size
	$Load.position = screen_size/2 - $Load.size/2


func _on_load_pressed():
	$Load.hide()
	pass # Replace with function body.
