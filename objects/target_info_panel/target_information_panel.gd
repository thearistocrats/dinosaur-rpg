extends Node2D

const dinosaur_script = preload("res://scripts/Dinosaur Scripts/Dinosaur.gd")

const action_script = dinosaur_script.action_script
var DamageTypes = action_script.DamageTypes
var ActionTypes = action_script.ActionTypes

var panel_dimensinos = Vector2(250,0)
#this displays important information about the dinosaur
'''
name
health
stamina
armor
'''

func _ready():
	$CollisionShape2D.shape.size = card_dimensions

func set_card(action, new_index, action_type):
	index = new_index
	match action.action_type:
		ActionTypes.ATTACK:
			set_attack_card_text(action)
		ActionTypes.HEAL:
			set_heal_card_text(action)

func set_attack_card_text(attack:action_script.Attack):
	$Name.text = attack.name
	$Information.text = "DMG: "+str(attack.damage)+"\nST: "+str(attack.stamina_cost)+"\n"+DamageTypes.keys()[attack.damage_type]

func set_heal_card_text(heal:action_script.Heal):
	$Name.text = heal.name
	$Information.text = "HP: "+str(heal.heal)+"\nST: "+str(heal.stamina_cost)+("\nOverheal"if heal.is_over_heal else "\n ")
	pass

func _on_selected_card(_viewport, event, _shape_idx):
	if index < 0: pass
	if event is InputEventMouseButton && event.pressed:
		selected.emit(index)
		#print(index)

