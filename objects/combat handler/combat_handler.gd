extends Node2D

const dinosaur_script = preload("res://scripts/dinosaur scripts/Dinosaur.gd")
const turn_handler = preload("res://scripts/trainer scripts/turn handler.gd")
const trainer_script = preload("res://scripts/trainer scripts/Trainer.gd")
const gui_script = preload("res://gui/gui scripts.gd")
const action_script = dinosaur_script.action_script

@export var action_card_scene: PackedScene
var action_cards = []
@export var information_panel_scene: PackedScene
var information_panel

const Teams = dinosaur_script.Teams
var screen_size
var roster = [[], []]
var attacking_dino
var target_dino
var current_turn = Teams.PLAYER_TEAM
var controlled_team = Teams.PLAYER_TEAM

func setup_misc():
	screen_size = get_viewport_rect().size
	
	$"Attacking dino".set_corner_sprite(0)
	$"Target dino".set_corner_sprite(1)
	$"Selected Action".set_corner_sprite(2)
	hide()
	
func populate_teams(player_team:Array, enemy_team:Array):
	for dino in player_team:
		roster[Teams.PLAYER_TEAM].append(dino)
		dino.selected.connect(set_source_and_target)
		dino.hide()
	for dino in enemy_team:
		roster[Teams.ENEMY_TEAM].append(dino)
		dino.selected.connect(set_source_and_target)
		dino.hide()

func start_encounter():
	show()
	screen_size = get_viewport_rect().size
	$"End Turn Button".position = Vector2(screen_size.x/2 - $"End Turn Button".size.x/2, screen_size.y - $"End Turn Button".size.y)
	$"Inventory".position = Vector2(0, screen_size.y - $"Inventory".size.y)
	$"Current Turn".position = Vector2.ZERO
	$"Current Turn".text = Teams.keys()[current_turn]
	
	set_roster_positions(Teams.PLAYER_TEAM)
	set_roster_positions(Teams.ENEMY_TEAM)
	gui_script.position_team_on_screen(screen_size, Teams.PLAYER_TEAM, roster[Teams.PLAYER_TEAM])
	gui_script.position_team_on_screen(screen_size, Teams.ENEMY_TEAM, roster[Teams.ENEMY_TEAM])
	
func end_encounter():
	clear_action_bar()
	clear_information_panel()
	delete_all_from_team(Teams.PLAYER_TEAM)
	delete_all_from_team(Teams.ENEMY_TEAM)

func add_dino_to_team(dinosaur_to_add:PackedScene, team:Teams):
	var dino = dinosaur_to_add.instantiate()
	add_child(dino)
	
	
#this will get moved to the scripts that handle inventory
func set_roster_positions(team: Teams):
	var i = 0
	for dino in roster[team]:
		dino.identity.set_position(Vector2i(team, i))
		i += 1

func set_source_and_target(pointer:Vector2i, is_source:bool):
	if pointer == null || pointer < Vector2i.ZERO:
		print("invalid pointer!")
		return
	var selected_dino = roster[pointer.x][pointer.y]
	
	var name = selected_dino.identity.name
	if is_source: 
		attacking_dino = selected_dino
		#self.source_dino = roster[] dinosaur_pointer
		set_action_cards()
		print("setting source to " + name + " at position " + str(pointer))
		$"Attacking dino".position_corners(selected_dino.position, Vector2i(96,96))
		$"Selected Action".hide()
	else: 
		target_dino = selected_dino
		#self.target_dino = dinosaur_pointer
		display_information_panel()
		print("setting target to " + name + " at position " + str(pointer))
		$"Target dino".position_corners(selected_dino.position, Vector2i(96,96))

func set_action_cards():
	clear_action_bar()
	if attacking_dino == null:# Vector2i.ZERO:
		print("no source selected!")
		return
	var available_actions = attacking_dino.action_list.get_actions()
	var i = 0
	if available_actions == []: return
	for action in available_actions:
		var card = action_card_scene.instantiate()
		add_child(card)
		action_cards.append(card)
		card.selected.connect(do_player_action)
		card.set_card(action, i)
		i += 1
	gui_script.position_action_bar_on_screen(screen_size, action_cards)
		
func display_information_panel():
	clear_information_panel()
	if target_dino == null:# < Vector2i.ZERO:
		print("no target selected!")
		return
	information_panel = information_panel_scene.instantiate()
	add_child(information_panel)
	information_panel.set_panel(target_dino.dinosaur)
	gui_script.position_information_panel_on_screen(screen_size, information_panel)

	
func swap_turn():
	regen_team_stamina(current_turn, false)
	if current_turn == Teams.ENEMY_TEAM:
		current_turn = Teams.PLAYER_TEAM
		$"Current Turn".position = Vector2.ZERO
	elif current_turn == Teams.PLAYER_TEAM:
		current_turn = Teams.ENEMY_TEAM
		$"Current Turn".position = Vector2(screen_size.x-$"Current Turn".size.x, 0)
	$"Current Turn".text = Teams.keys()[current_turn]
	regen_team_stamina(current_turn, true)
	print("\n"+Teams.keys()[current_turn]+":")
	if current_turn == Teams.ENEMY_TEAM:do_enemy_turn()
	
func _on_inventory_pressed():
	print("Not yet implemented!")
	
func get_trainers():
	pass
func win_handler():
	pass

func action_handler(selected_move:int):
	#print("comparing"+str(target_dino)+str(Vector2i.ZERO))
	if attacking_dino == null:# < Vector2i.ZERO:
		print("no target selected!")
		return
	if target_dino == null:# < Vector2i.ZERO:
		print("no source selected!")
		return
		
	var available_actions = attacking_dino.dinosaur.action_list.get_actions()
	if attacking_dino.stamina.current_stamina < available_actions[selected_move].stamina_cost:
		print("Not enough stamina")
		return
	if target_dino.dinosaur.health.is_dead:
		print("dead dino!")
		return
	
	attacking_dino.act_on_action(available_actions[selected_move], attacking_dino.dinosaur, true)
	target_dino.act_on_action(available_actions[selected_move], attacking_dino.dinosaur, false)
	set_action_cards()
	display_information_panel()
	print(available_actions[selected_move].name + " from " + attacking_dino.identity.name + str(attacking_dino.identity.position) + " to " + target_dino.identity.name + str(target_dino.identity.position))

func do_player_action(selected_action:int):
	if current_turn != controlled_team:
		print("Not your turn yet!")
		return
	if attacking_dino.identity.team != controlled_team:
		print("not your dino!")
		return
	action_handler(selected_action)
	$"Selected Action".position_corners(action_cards[selected_action].position, action_cards[selected_action].get_size()/2)

func regen_team_stamina(team:Teams, is_start_of_turn:bool):
	for dino in roster[team]:
		if dino.stamina.regen_before_turn == is_start_of_turn:
			dino.stamina.regen_stamina(dino.stamina.stamina_regen)
	
func do_enemy_turn():
	var temp_attacking = Vector2i(-1,-1)
	var temp_target = Vector2i(-1,-1)
	if !(attacking_dino == null || target_dino == null):
		temp_attacking = attacking_dino.identity.position
		temp_target = target_dino.identity.position
	
	var turn = turn_handler.new()
	var beefstick = trainer_script.Trainer.new("beefstick",false)
	beefstick.set_strategies(0,0,0,0)
	turn.ended_turn.connect(swap_turn)
	turn.do_action.connect(action_handler)
	turn.set_dino_pointer.connect(set_source_and_target)
	turn.set_teams(roster, Teams.ENEMY_TEAM, Teams.PLAYER_TEAM)
	turn.set_trainer(beefstick)
	turn.do_turn()
	
	set_source_and_target(temp_attacking, true)
	set_source_and_target(temp_target, false)
	clear_action_bar()
	
func delete_all_from_team(team: Teams):
	for dino in roster[team]:
		print("Good bye " + dino.identity.dino_name)
		dino.queue_free()
func clear_action_bar():
	for card in action_cards: card.queue_free()
	action_cards = []
func clear_information_panel():
	if information_panel != null: information_panel.queue_free()

