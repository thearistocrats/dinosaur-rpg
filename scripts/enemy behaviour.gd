const dinosaur_script = preload("res://scripts/Dinosaur Scripts/Dinosaur.gd")
const action_script = dinosaur_script.action_script
const Teams = dinosaur_script.identity_script.Teams

var controlled_team:Teams
var roster = [[],[]]

enum StratStEcon {
	ALL,
	RANDOM,
	RANDOMINRANGE,
	REGENFULL,
	RATIO
}
enum StratSource {
	RANDOM,
	ROUND_ROBIN,
	HIGHEST_STAMINA,
	HIGHEST_MAX_DAMAGE,
}
enum StratAction {
	RANDOM,
	ROUND_ROBIN,
	HIGHEST_DAMAGE,
	LOWEST_STAMINA,
	HIGHEST_DAMAGE_PER_STAMINA
}
enum StratTarget {
	RANDOM,
	ROUND_ROBIN,
	HIGHEST_HEALTH,
	LOWEST_HEALTH
}

signal ended_turn
var strategy:Vector4i

func do_turn():
	end_turn()
	
func end_turn_decider(economy_strategy:StratStEcon)->bool:
	match strategy.w:
		StratStEcon.ALL:
			for dino in roster[controlled_team]:
				if dino.dinosaur.get_available_actions != []:
					return false
				return true
		_:
			print(StratStEcon.keys()[strategy.w]+" not yet implemented!")
			return true
	return true

func end_turn():
	ended_turn.emit()

func set_roster(_roster):self.roster = _roster
func set_controlled_team(_controlled_team:Teams):self.controlled_team = _controlled_team
func set_strategy(stamin_econ:StratStEcon, source:StratSource, action:StratAction, target:StratTarget):
	strategy = Vector4i(stamin_econ, source, action, target)
