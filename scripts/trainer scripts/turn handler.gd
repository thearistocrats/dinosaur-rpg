const dinosaur_script = preload("res://scripts/dinosaur scripts/Dinosaur.gd")
const trainer_script = preload("res://scripts/trainer scripts/Trainer.gd")
const action_script = dinosaur_script.action_script

const Teams = dinosaur_script.identity_script.Teams
const TurnOrder = trainer_script.TurnOrder
const TurnEconomy = trainer_script.TurnEconomy
const Target = trainer_script.Target
const Action = trainer_script.Action

var controlled_team:Teams
var enemy_team:Teams
var roster = [[],[]]
var turn_order = []
var targetable_dino = []
var trainer:trainer_script.Trainer

signal set_dino_pointer(source_dino:Vector2i, is_source:bool)
signal do_action(selected_move:int)
signal ended_turn

func do_turn():
	if !has_prequisites():
		end_turn()
		return
	
	turn_order = trainer_script.get_turn_order(trainer.turn_order_strategy, roster[controlled_team])
	var previous_target = -1
	for i in turn_order:
		print("doing "+str(roster[controlled_team][i].identity.position)+"'s turn")
		var previous_action = -1
		while(!trainer_script.end_dino_turn(trainer.turn_enconomy_strategy, roster[controlled_team][i].dinosaur)):
			if roster[controlled_team][i].health.is_dead:break
			targetable_dino = trainer_script.get_targetable_dino(roster[enemy_team])
			if targetable_dino == []:
				end_turn()
				return
			var target = trainer_script.get_target(trainer.target_strategy, targetable_dino, roster[enemy_team], previous_target)
			var action = trainer_script.get_action(trainer.action_strategy, roster[controlled_team][i].dinosaur, previous_action)
			#print("setting pointers: "+str(Vector2i(controlled_team,i))+str(Vector2i(enemy_team,target)))
			set_dino_pointer.emit(Vector2i(controlled_team,i), true)
			set_dino_pointer.emit(Vector2i(enemy_team,target), false)
			do_action.emit(roster[controlled_team][i].dinosaur.get_available_actions_by_index()[action])
			previous_action = action
			previous_target = target
	end_turn()
	
func end_turn():
	ended_turn.emit()
	
func has_prequisites()->bool:
	var has_prequisites = true
	if trainer == null:
		print("No trainer! proceeding with random strategys!")
		trainer = trainer_script.Trainer.new("randobot", false)
		trainer.set_strategy(
			randi()%(TurnOrder.keys().size()-1), 
			randi()%(TurnEconomy.keys().size()-1), 
			randi()%(Target.keys().size()-1), 
			randi()%(Action.keys().size())-1)
	if self.controlled_team == null:
		print("controlled_team not set!")
		has_prequisites = false
	if self.enemy_team == null:
		print("enemy_team not set!")
		has_prequisites = false
	if self.roster == [[],[]]:
		print("roster not set!")
		has_prequisites = false
	return has_prequisites
	
func set_teams(_roster:Array, _controlled_team:Teams, _enemy_team:Teams):
	self.controlled_team = _controlled_team
	self.enemy_team = _enemy_team
	self.roster = _roster
func set_trainer(_trainer:trainer_script.Trainer):self.trainer = _trainer
