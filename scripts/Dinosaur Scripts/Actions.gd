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
	HEAL
}

class ActionList:
	var actions = []
	func set_action_index():
		var i = 0
		for action in actions:
			action.index = i
			i += 1
	func get_actions():return actions

#All actions must have variables to fill in: type, index, name, and stamina cost
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
