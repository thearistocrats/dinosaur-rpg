extends Area2D

const dinosaur_script = preload("res://scripts/Dinosaur Scripts/Dinosaur.gd")

const DinosaurTypes = dinosaur_script.DinosaurTypes
const Teams = dinosaur_script.Teams
const DamageTypes = dinosaur_script.DamageTypes
const ActionTypes = dinosaur_script.ActionTypes

#gets data from the inspector to make changing stats easier
@export_group("Dino data")
@export var _dinosaur_name: String
@export var _dinosaur_type: DinosaurTypes

@export_group("Health Numbers")
@export var _max_health: float
@export var _starting_health: float
@export var _min_health: float

@export_group("Stamina")
@export var _max_stamina: int
@export var _stamina_regen: int
@export var _regen_before_turn: bool

@export_group("Armor Values")
@export var _armour_flat: float
@export var _armour_percent: float

@export_group("misc")
@export var _rotation: float
@export var _is_flipped_h: bool
@export var _is_flipped_v: bool
#these will only be used to populate the dinosaur class, they are prefaced with _ because they are not to be used anywhere else
#the dinosaur script is to make it so we can make any dinosur interface with any other dinosuars

var dinosaur = dinosaur_script.Dinosaur.new()
var identity = dinosaur.identity
var health = dinosaur.health
var stamina = dinosaur.stamina
var armor = dinosaur.armor
var action_list = dinosaur.action_list

var past_health = dinosaur_script.health_script.Health.new()
var past_stamina = dinosaur_script.stamina_script.Stamina.new()

#var past_health = dinosaur_script.Health.new(health.get_variables())

#signals
signal dinosaur_hit
signal dinosaur_killed
signal out_of_stamina
signal attempt_attack(damage:float, attack_type: DinosaurTypes)
signal selected(position:Vector2i, is_left_click:bool)

func _ready():
	identity.set_stats(_dinosaur_name, _dinosaur_type)
	health.set_stats(_max_health, _starting_health, _min_health, _max_health, false)
	stamina.set_stats(_max_stamina, _stamina_regen, _stamina_regen, _regen_before_turn)
	armor.set_stats(_armour_flat, _armour_percent)
	
	action_list.actions.append(dinosaur_script.action_script.Attack.new("Weak Attack", 3, 15.0, DamageTypes.SLASHING))
	action_list.actions.append(dinosaur_script.action_script.Attack.new("Regular Attack", 5, 35.0, DamageTypes.BLUDGEONING))
	action_list.actions.append(dinosaur_script.action_script.Attack.new("big fuck off attack", 8, 85.0, DamageTypes.NECROTIC))
	action_list.actions.append(dinosaur_script.action_script.Heal.new("heal", 2, 65.0, false))
	action_list.actions.append(dinosaur_script.action_script.Heal.new("over heal", 3, 25.0, true))
	action_list.set_action_index()
	
	past_health.sync(health)
	past_stamina.sync(stamina)
	
	$"Name tag".text = identity.dino_name
	$Health_Bar.set_health_bar(health, stamina)
	$Sprites.play("default")
	
func _process(_delta):
	act_on_stat()
	
func act_on_stat():
	update_stats()
	if past_health.current_health != health.current_health:
		#func update_health_Bar(): this should be its own function but its fine here now
		$Health_Bar.update_health(health)
		past_health.current_health = health.current_health
		act_on_stat()
	if past_stamina.current_stamina != stamina.current_stamina:
		#func update_health_Bar(): this should be its own function but its fine here now
		$Health_Bar.update_stamina(stamina)
		past_stamina.current_stamina = stamina.current_stamina
		act_on_stat()
	if past_stamina.out_of_stamina != stamina.out_of_stamina:
		exhausted_dino()
		act_on_stat()
	if past_health.is_dead != health.is_dead: 
		kill_dinosaur() if health.is_dead else revive_dinosaur()
		act_on_stat()
	pass
	
#use this to update any stats that wouldn't be updated elsewhere
func update_stats():
	health.is_dead = health.current_health <= health.min_health
	stamina.out_of_stamina = stamina.current_stamina <= stamina.min_stamina
	
func _on_selected_dino(_viewport, event, _shape_idx):
	if event is InputEventMouseButton && event.pressed:
		selected.emit(identity.roster_position, event.button_index == MOUSE_BUTTON_LEFT)
		#print(dinosaur.roster_position)

#calling this kills the dinosaur
func kill_dinosaur():
	health.is_dead = true
	past_health.is_dead = health.is_dead
	health.current_health = health.min_health
	dinosaur_killed.emit()
	$Sprites.play("death_animation")
	print("ouch!")

#calling this revives the dinosaur
func revive_dinosaur():
	health.is_dead = false
	past_health.is_dead = health.is_dead
	$Sprites.play("default")
	print("we are so back")

func exhausted_dino():
	stamina.out_of_stamina = true
	past_stamina.out_of_stamina = stamina.out_of_stamina
	stamina.current_stamina = stamina.min_stamina
	out_of_stamina.emit()
	print("eepy tired dino")

#calling this sets the rotation and flip
func rotate_and_flip(rotation: float, is_flipped_h: bool, is_flipped_v: bool):
	$Sprites.set_rotation_degrees(rotation)
	$Sprites.flip_h = is_flipped_h
	$Sprites.flip_v = is_flipped_v

func act_on_action(action, is_source:bool):dinosaur.match_action(action, is_source)
