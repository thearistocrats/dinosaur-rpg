extends Node2D

var top_left
var top_right
var bottom_left
var bottom_right

enum CornerColors{
	YELLOW,
	RED,
	GREEN
}

func _ready():
	top_left = $"Top Left"
	top_right = $"Top Right"
	bottom_left = $"Bottom Left"
	bottom_right = $"Bottom Right"
	set_corner_sprite(0)
	hide()

func set_corner_sprite(color:CornerColors):
	top_left.play(CornerColors.keys()[color])
	top_right.play(CornerColors.keys()[color])
	bottom_left.play(CornerColors.keys()[color])
	bottom_right.play(CornerColors.keys()[color])

func position_corners(position_on_screen:Vector2, size:Vector2):
	size = size/4
	top_left.position = Vector2(position_on_screen.x - size.x, position_on_screen.y - size.y)
	top_right.position = Vector2(position_on_screen.x + size.x, position_on_screen.y - size.y)
	bottom_left.position = Vector2(position_on_screen.x - size.x, position_on_screen.y + size.y)
	bottom_right.position = Vector2(position_on_screen.x + size.x, position_on_screen.y + size.y)
	show()
