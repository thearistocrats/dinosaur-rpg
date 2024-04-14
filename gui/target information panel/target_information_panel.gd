extends Node2D

const dinosaur_script = preload("res://scripts/dinosaur scripts/Dinosaur.gd")

const action_script = dinosaur_script.action_script
const DamageTypes = action_script.DamageTypes
const ActionTypes = action_script.ActionTypes

const panel_dimensions = Vector2(250,500)
#this displays important information about the dinosaur
'''
name
health
stamina
armor
'''

func _ready():
	$"Panel".shape.size = panel_dimensions
	
func set_panel(dinosaur:dinosaur_script.Dinosaur):
	$Name.text = dinosaur.identity.name
	$Health.text = "HP:"+str(dinosaur.health.current_health)
	$Stamina.text = "ST:"+str(dinosaur.stamina.current_stamina)
	$Information.text = dinosaur.get_description_for_that_one_information_panel()

func get_panel_size() -> Vector2:
	return $Panel.shape.size
