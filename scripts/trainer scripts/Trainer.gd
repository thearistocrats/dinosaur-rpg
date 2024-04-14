const dinosaur_script = preload("res://scripts/dinosaur scripts/Dinosaur.gd")

enum TurnOrder {
	ROUND_ROBIN,
	RANDOM,
	HIGHEST_STAMINA,
	HIGHEST_MAX_DAMAGE,
}
enum Target {
	FIRST,
	RANDOM,
	ROUND_ROBIN,
	HIGHEST_HEALTH,
	LOWEST_HEALTH
}
enum TurnEconomy {
	ALL,
	RANDOM,
	RANDOMINRANGE,
	REGENFULL,
	RATIO
}
enum Action {
	RANDOM,
	ROUND_ROBIN,
	HIGHEST_DAMAGE,
	LOWEST_STAMINA,
	HIGHEST_DAMAGE_PER_STAMINA
}
class Trainer:
	var name:String
	var roster = []
	var inventory = []
	var turn_order_strategy:TurnOrder
	var target_strategy:Target
	var turn_enconomy_strategy:TurnEconomy
	var action_strategy:Action
	var is_player:bool
	func _init(_name:String, _is_player):
		self.name = _name
		self.is_player = _is_player
	func set_strategies( _turn_order_strategy:TurnOrder, _target_strategy:Target, _turn_enconomy_strategy:TurnEconomy, _action_strategy:Action):
		self.turn_order_strategy = _turn_order_strategy
		self.target_strategy = _target_strategy
		self.turn_enconomy_strategy = _turn_enconomy_strategy
		self.action_strategy = _action_strategy
	func add_dino_to_roster(dino:Area2D):
		roster.append(dino)
	func add_item_to_inventory(item:Area2D):
		inventory.append(item)

static func end_dino_turn(strategy:TurnEconomy, dino:dinosaur_script.Dinosaur)->bool:
	var available_actions = dino.get_available_actions_by_index()
	if available_actions == []: return true
	match strategy:
		TurnEconomy.ALL:
			return false
		TurnEconomy.RANDOM:
			return dino.stamina.current_stamina <= randi()%dino.stamina.max_stamina#minstamina
		_:
			var default_strategy = TurnEconomy.ALL
			print("Strategy "+TurnEconomy.keys()[strategy]+" not yet implemented! proceeding with "+TurnEconomy.keys()[default_strategy])
			return end_dino_turn(default_strategy, dino)

static func get_action(strategy:Action, dino:dinosaur_script.Dinosaur, previous_action:int)->int:
	var available_actions = dino.get_available_actions_by_index()
	if available_actions == []:return -1
	match strategy:
		Action.RANDOM:
			return randi()%available_actions.size()
		_:
			var default_strategy = Action.RANDOM
			print("Strategy "+TurnOrder.keys()[strategy]+" not yet implemented! proceeding with "+TurnOrder.keys()[default_strategy])
			return get_action(default_strategy, dino, previous_action)

static func get_targetable_dino(enemy_roster:Array)->Array:
	var targetable_dino = []
	for dino in enemy_roster:
		if !dino.health.is_dead:
			targetable_dino.append(dino.identity.position.y)
	return targetable_dino

static func get_target(strategy:Target, targetable_dino:Array, enemy_roster:Array, previous_target:int)->int:
	if targetable_dino == []:return -1
	#print(targetable_dino)
	match strategy:
		Target.FIRST:
			return targetable_dino[0]
		Target.RANDOM:
			return targetable_dino[randi()%targetable_dino.size()]
		Target.ROUND_ROBIN:
			var target = previous_target + 1
			while !(target in targetable_dino):
				if target > targetable_dino.size()-1:
					target = 0
					break
				target += 1
			return target
		Target.HIGHEST_HEALTH:
			var target = targetable_dino[0]
			for i in targetable_dino:
				if enemy_roster[i].health.current_health > enemy_roster[target].health.current_health:
					target = i
			return target
		Target.LOWEST_HEALTH:
			var target = targetable_dino[0]
			for i in targetable_dino:
				if enemy_roster[i].health.current_health < enemy_roster[target].health.current_health:
					target = i
			return target
		_:
			var default_strategy = Target.FIRST
			print("Strategy "+Target.keys()[strategy]+" not yet implemented! proceeding with "+Target.keys()[default_strategy])
			return get_target(default_strategy, targetable_dino, enemy_roster, previous_target)
				
static func get_turn_order(strategy:TurnOrder, controlled_roster:Array)->Array:
	var turn_order = []
	for dino in controlled_roster:
		turn_order.append(dino.identity.position.y)
	match strategy:
		TurnOrder.ROUND_ROBIN:
			return turn_order
		TurnOrder.RANDOM:
			turn_order.shuffle()
			return turn_order
		TurnOrder.HIGHEST_STAMINA:
			var is_not_sorted = true
			while(is_not_sorted):
				is_not_sorted = false
				for i in range(turn_order.size()-1):
					if controlled_roster[turn_order[i]].stamina.current_stamina < controlled_roster[turn_order[i+1]].stamina.current_stamina:
						var temp = turn_order[i]
						turn_order[i] = turn_order[i+1]
						turn_order[i+1] = temp
						is_not_sorted = true
			return turn_order
		_:
			var default_strategy = TurnOrder.ROUND_ROBIN
			print("Strategy "+TurnOrder.keys()[strategy]+" not yet implemented! proceeding with "+TurnOrder.keys()[default_strategy])
			return get_turn_order(default_strategy, controlled_roster)
