extends Area2D

var card_dimensions = Vector2(150, 200)

const dinosaur_script = preload("res://scripts/dinosaur scripts/Dinosaur.gd")
const action_script = dinosaur_script.action_script

signal selected(index: int)
var index = -1

func _ready():
	$CollisionShape2D.shape.size = card_dimensions

func set_card(action, new_index):
	index = new_index
	$Name.text = action.name
	$Information.text = action.get_card_description()
	
func _on_selected_card(_viewport, event, _shape_idx):
	if index < 0: return
	if event is InputEventMouseButton && event.pressed:
		selected.emit(index)
		#print(index)
func get_size()->Vector2:
	return $CollisionShape2D.shape.size
