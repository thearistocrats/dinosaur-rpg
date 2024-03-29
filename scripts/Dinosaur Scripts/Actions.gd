enum DamageTypes{
	ACID,
	BLUDGEONING,
	COLD,
	FIRE,
	FORCE,
	LIGHTNING,
	NECROTIC,
	PIERCING,
	POISON,
	PSYCHIC,
	RADIANT,
	SLASHING,
	THUNDER
}

enum ActionTypes{
	ATTACK,
	HEAL,
	STAMINABOOST
}

class ActionList:
	var actions = []
	func set_action_index():
		var i = 0
		for action in actions:
			action.index = i
			i += 1
	func get_actions():return actions
	func get_available_actions(current_stamina:int):
		var available_actions = []
		for action in self.actions:
			if action.stamina_cost >= current_stamina: available_actions.append(action)
		return available_actions

#all actions need to have the following:
class Action:
	const action_type = ActionTypes.ATTACK #for a new action, add the type to ActionTypes, and add functionality to the dinosaur script
	var index:int #this is used to track the actions position in the action list, there may be a better way to do this
	#rework card and the action selectino to remove this
	var name:String #the name of the action
	var stamina_cost:int #set to 0 to not have any stamina cost
	func _init(name:String, stamina_cost:int):
		self.name = name
		self.stamina_cost = stamina_cost
	func get_card_description() -> String: #used in the action card to describe what the action will do at a glance
		return ""

class Attack:
	const action_type = ActionTypes.ATTACK
	var index:int
	var name:String
	var stamina_cost:int
	var damage: float
	var damage_type: DamageTypes
	func _init(name:String, stamina_cost:int, damage:float, damage_type:DamageTypes):
		self.name = name
		self.stamina_cost = stamina_cost
		self.damage = damage
		self.damage_type = damage_type
	func get_card_description() -> String:
		return "DMG: "+str(self.damage)+"\nST: "+str(self.stamina_cost)+"\n"+DamageTypes.keys()[self.damage_type]

class Heal:
	const action_type = ActionTypes.HEAL
	var index:int
	var name:String
	var stamina_cost:int
	var heal: float
	var is_over_heal: bool
	func _init(name:String, stamina_cost:int, heal: float, is_over_heal: bool):
		self.name = name
		self.stamina_cost = stamina_cost
		self.heal = heal
		self.is_over_heal = is_over_heal
	func get_card_description() -> String:
		return "HP: "+str(self.heal)+"\nST: "+str(self.stamina_cost)+("\nOverheal"if self.is_over_heal else "\n ")

class StaminaBoost:
	const action_type = ActionTypes.STAMINABOOST
	var index:int
	var name:String
	var stamina_cost:int
	var stamina_boost:int
	func _init(name:String, stamina_cost:int, stamina_boost: int):
		self.name = name
		self.stamina_cost = stamina_cost
		self.stamina_boost = stamina_boost
	func get_card_description() -> String:
		return "Regen: "+str(self.stamina_boost)+"\nST: "+str(self.stamina_cost)
