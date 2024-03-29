const identity_script = preload("res://scripts/Dinosaur Scripts/Identity.gd")
const health_script = preload("res://scripts/Dinosaur Scripts/Health.gd")
const stamina_script = preload("res://scripts/Dinosaur Scripts/Stamina.gd")
const armor_script = preload("res://scripts/Dinosaur Scripts/Armor.gd")
const action_script = preload("res://scripts/Dinosaur Scripts/Actions.gd")

const DinosaurTypes = identity_script.DinosaurTypes
const Teams = identity_script.Teams
const DamageTypes = action_script.DamageTypes
const ActionTypes = action_script.ActionTypes

class Dinosaur:
	var identity = identity_script.Identity.new()
	var health = health_script.Health.new()
	var stamina = stamina_script.Stamina.new()
	var armor = armor_script.Armor.new()
	var action_list = action_script.ActionList.new()
	
	func get_description_for_that_one_information_panel() -> String:
		return identity.get_type_as_string()+"\narmor flat: "+str(armor.armour_flat)+"\narmor percent: "+str(armor.armour_percent)
	
	func get_available_actions():return action_list.get_available_actions(stamina.current_stamina)
	
	func match_action(action, is_sending_action:bool):
		match action.action_type:
			ActionTypes.ATTACK:
				sending_attack(action) if is_sending_action else recieving_attack(action)
			ActionTypes.HEAL:
				sending_heal(action) if is_sending_action else recieving_heal(action)
			ActionTypes.STAMINABOOST:
				sending_stamina_boost(action) if is_sending_action else recieving_stamina_boost(action)
			_:
				print("action is not implemented!")
	
	func sending_attack(attack:action_script.Attack):
		stamina.reduce_stamina(attack.stamina_cost)
	func recieving_attack(attack:action_script.Attack):
		health.damage_dinosaur(armor.calc_armor_negation(attack.damage))
		
	func sending_heal(heal:action_script.Heal):
		stamina.reduce_stamina(heal.stamina_cost)
	func recieving_heal(heal:action_script.Heal):
		health.heal_dinosaur(heal.heal) if !heal.is_over_heal else health.over_heal_dinosaur(heal.heal)
		
	func sending_stamina_boost(stamina_boost:action_script.StaminaBoost):
		stamina.reduce_stamina(stamina_boost.stamina_cost)
	func recieving_stamina_boost(stamina_boost:action_script.StaminaBoost):
		stamina.regen_stamina(stamina_boost.stamina_boost)
	
