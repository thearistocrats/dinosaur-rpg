extends Node2D

const dinosaur_script = preload("res://scripts/Dinosaur Scripts/Dinosaur.gd")
const enemy_script = preload("res://scripts/enemy behaviour.gd")
const action_script = dinosaur_script.action_script

@export var dinosaur_scene: PackedScene
@export var action_card_scene: PackedScene
var action_cards = []
@export var information_panel_scene: PackedScene
var information_panel

const Teams = dinosaur_script.Teams
var screen_size

var roster = [[], []]
var available_actions = []

var current_turn = Teams.PLAYER_TEAM

const invalid_vector = Vector2i(-1,-1)
const invalid_index = -1
var source_dino = invalid_vector
var target_dino = invalid_vector
var selected_move = invalid_index

func _ready():
	screen_size = get_viewport_rect().size
	$"End Turn Button".position = Vector2(screen_size.x/2 - $"End Turn Button".size.x/2, screen_size.y - $"End Turn Button".size.y)
	$"Inventory".position = Vector2(0, screen_size.y - $"Inventory".size.y)
	
	add_dino_to_team(dinosaur_scene, Teams.PLAYER_TEAM)
	add_dino_to_team(dinosaur_scene, Teams.PLAYER_TEAM)
	add_dino_to_team(dinosaur_scene, Teams.ENEMY_TEAM)
	add_dino_to_team(dinosaur_scene, Teams.ENEMY_TEAM)
	add_dino_to_team(dinosaur_scene, Teams.ENEMY_TEAM)
	add_dino_to_team(dinosaur_scene, Teams.ENEMY_TEAM)
	
	start_encounter()

func start_encounter():
	set_roster_positions(Teams.PLAYER_TEAM)
	set_roster_positions(Teams.ENEMY_TEAM)
	position_team(Teams.PLAYER_TEAM)
	position_team(Teams.ENEMY_TEAM)
func end_encounter():
	delete_all_from_team(Teams.PLAYER_TEAM)
	delete_all_from_team(Teams.ENEMY_TEAM)

func add_dino_to_team(dinosaur_to_add:PackedScene, team:Teams):
	var dino = dinosaur_to_add.instantiate()
	add_child(dino)
	roster[team].append(dino)
	dino.selected.connect(set_source_and_target)
	dino.hide()
	
func set_roster_positions(team: Teams):
	var i = 0
	for dino in roster[team]:
		dino.identity.set_roster_position(Vector2i(team, i))
		i += 1

func position_team(team: Teams):
	var center = screen_size/2
	var dino_offset = 150
	var window_offset = 250
	
	match team:
		Teams.PLAYER_TEAM:
			center = Vector2(window_offset, window_offset)
		Teams.ENEMY_TEAM:
			center = Vector2(screen_size.x - window_offset, window_offset)
			
	roster[team][0].position = center
	roster[team][0].show()
	for i in roster[team].size()-1:
		var angle = float(i*2) / float(roster[team].size()-1) * PI - (PI/2.0)
		var new_position = Vector2(cos(angle) * dino_offset + center.x, sin(angle) * dino_offset + center.y)
		roster[team][i+1].position = new_position
		roster[team][i+1].show()
		#print("putting " + roster[team][i+1].identity.dino_name + " at position " + str(roster[team][i+1].position))

func set_source_and_target(dinosaur_pointer:Vector2i, is_left_click:bool):
	var dino_name = roster[dinosaur_pointer.x][dinosaur_pointer.y].identity.dino_name
	if is_left_click: 
		source_dino = dinosaur_pointer
		display_action_bar()
		print("setting source to " + dino_name + " at position " + str(dinosaur_pointer))
	else: 
		target_dino = dinosaur_pointer
		display_information_panel()
		print("setting target to " + dino_name + " at position " + str(dinosaur_pointer))

func display_action_bar():
	clear_action_bar()
	if source_dino < Vector2i.ZERO:
		print("no source selected!")
		return
	available_actions = roster[source_dino.x][source_dino.y].dinosaur.action_list.get_actions()
	if available_actions == []: return
	
	var card_size
	var vertical_offset = 150
	var horizontal_offset = 100
	var card_position = Vector2(horizontal_offset, screen_size.y-vertical_offset)
	var i = 0
	for action in available_actions:
		var card = action_card_scene.instantiate()
		add_child(card)
		card_size = card.get_size()
		action_cards.append(card)
		card.selected.connect(do_action)
		card.position = card_position
		card.set_card(action, i)
		i += 1
		card_position.x += card_size.x
		
func display_information_panel():
	clear_information_panel()
	if target_dino < Vector2i.ZERO:
		print("no source selected!")
		return
	if information_panel != null: information_panel.queue_free()
	information_panel = information_panel_scene.instantiate()
	add_child(information_panel)
	var panel_size = information_panel.get_panel_size()
	information_panel.position = Vector2(screen_size.x/2, panel_size.y/2)
	information_panel.set_panel(roster[target_dino.x][target_dino.y].dinosaur)
	information_panel.show()

func do_action(action_index:int):
	selected_move = action_index
	if current_turn != Teams.PLAYER_TEAM:
		print("Not your turn yet!")
		return
	if target_dino == invalid_vector:
		print("no target selected!")
		return
	if source_dino == invalid_vector:
		print("no source selected!")
		return
	if roster[source_dino.x][source_dino.y].dinosaur.stamina.current_stamina < available_actions[selected_move].stamina_cost:
		print("Not enough stamina")
		return
	if roster[source_dino.x][source_dino.y].dinosaur.health.is_dead:
		print("dead dino!")
		return
	roster[source_dino.x][source_dino.y].act_on_action(available_actions[selected_move], true)
	roster[target_dino.x][target_dino.y].act_on_action(available_actions[selected_move], false)
	display_action_bar()
	display_information_panel()
	#print(available_actions[selected_move].name + " from " + roster[source_dino.x][source_dino.y].identity.dino_name + str(source_dino) + " to " + roster[target_dino.x][target_dino.y].identity.dino_name + str(target_dino))

func delete_all_from_team(team: Teams):
	for dino in roster[team]:
		print("Good bye " + dino.identity.dino_name)
		dino.queue_free()
func clear_action_bar():
	for card in action_cards: card.queue_free()
	available_actions = []
	action_cards = []
func clear_information_panel():
	if information_panel != null: information_panel.queue_free()

func _on_end_turn_pressed():
	if current_turn == Teams.ENEMY_TEAM:
		current_turn = Teams.PLAYER_TEAM
	elif current_turn == Teams.PLAYER_TEAM:
		current_turn = Teams.ENEMY_TEAM
	print("\n\n\n"+Teams.keys()[current_turn])
	#var enemy = enemy_script.new()
	#enemy.do_action_for_each_dino(roster, current_turn)
	
func _on_inventory_pressed():
	print("Not yet implemented!")
	
