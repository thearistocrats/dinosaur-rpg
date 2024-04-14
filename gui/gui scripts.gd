'''
const action_card = preload("res://gui/action card/action_card.tscn")
const health_bar = preload("res://gui/health bar/health_bar.tscn")
const selection_icon = preload("res://gui/selection corners/selection_gui.tscn")
const target_information_panel = preload("res://gui/target information panel/target_information_panel.tscn")
'''

const dinosaur_script = preload("res://scripts/dinosaur scripts/Dinosaur.gd")
const Teams = dinosaur_script.Teams

static func position_team_on_screen(screen_size:Vector2, team:Teams, team_roster:Array):
	if team_roster == []:return
	var center = screen_size/2
	var dino_offset = 150#magic number
	var window_offset = 250#magic number
	center = Vector2(window_offset, window_offset) if team == Teams.PLAYER_TEAM else Vector2(screen_size.x - window_offset, window_offset)
	
	team_roster[0].position = center
	team_roster[0].show()
	for i in team_roster.size()-1:
		var angle = float(i*2) / float(team_roster.size()-1) * PI - (PI/2.0)
		team_roster[i+1].position = Vector2(cos(angle) * dino_offset + center.x, sin(angle) * dino_offset + center.y)
		team_roster[i+1].show()

static func position_action_bar_on_screen(screen_size:Vector2, action_cards:Array):
	var vertical_offset = 150#magic number
	var horizontal_offset = 100#magic number
	var card_position = Vector2(horizontal_offset, screen_size.y-vertical_offset)
	for card in action_cards:
		card.position = card_position
		card_position.x += card.get_size().x
		card.show()

static func position_information_panel_on_screen(screen_size:Vector2, information_panel):
	information_panel.position = Vector2(screen_size.x/2, information_panel.get_panel_size().y/2)
	information_panel.show()

static func button_tricks():
	pass
static func selection_tricks():
	pass
