extends Area2D

const dinosaur_script = preload("res://scripts/dinosaur scripts/Dinosaur.gd")
const action_script = dinosaur_script.action_script

const DinosaurTypes = dinosaur_script.DinosaurTypes
const DamageTypes = dinosaur_script.DamageTypes

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
#these will only be used to populate the dinosaur class, they are prefaced with _ because they are not to be used anywhere else

#relevent stats are stored in the dinosaur class
var dinosaur = dinosaur_script.Dinosaur.new()
#references to the stats in the dinosaur class
var identity = dinosaur.identity
var health = dinosaur.health
var stamina = dinosaur.stamina
var armor = dinosaur.armor
var action_list = dinosaur.action_list
#used to store past states of the dinosaur
var past_health = dinosaur_script.health_script.Health.new()
var past_stamina = dinosaur_script.stamina_script.Stamina.new()

#signals
signal dinosaur_hit
signal dinosaur_killed
signal out_of_stamina
signal selected(position:Vector2i, is_left_click:bool)

func _ready():
	identity.set_stats(_dinosaur_name, _dinosaur_type)
	health.set_stats(_max_health, _starting_health, _min_health, _max_health, false)
	stamina.set_stats(_max_stamina, 0, _stamina_regen, _stamina_regen, _regen_before_turn)
	armor.set_stats(_armour_flat, _armour_percent)
	
	action_list.actions.append(action_script.Attack.new("bite", 2, 15.0, DamageTypes.PIERCING))
	action_list.actions.append(action_script.Attack.new("kick", 4, 25.0, DamageTypes.BLUDGEONING))
	
	past_health.sync(health)
	past_stamina.sync(stamina)
	
	$"Name tag".text = identity.name
	$Health_Bar.set_health_bar(health, stamina)
	$Sprites.play("default")
	
func act_on_action(action, dino:dinosaur_script.Dinosaur, is_source:bool):
	dinosaur.match_action(action, dino, is_source)
	act_on_stat()

func act_on_stat():
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
	if past_stamina.is_exhausted != stamina.is_exhausted:
		exhausted_dino() if stamina.is_exhausted else un_exhausted_dino()
		act_on_stat()
	if past_health.is_dead != health.is_dead: 
		kill_dinosaur() if health.is_dead else revive_dinosaur()
		act_on_stat()
	pass
	
func _on_selected_dino(_viewport, event, _shape_idx):
	if event is InputEventMouseButton && event.pressed:
		selected.emit(identity.position, event.button_index == MOUSE_BUTTON_LEFT)
		#print(dinosaur.roster_position)

#calling this kills the dinosaur
func kill_dinosaur():
	past_health.is_dead = health.is_dead
	#health.current_health = health.min_health
	dinosaur_killed.emit()
	$Sprites.play("death_animation")
	#print("ouch!")

#calling this revives the dinosaur
func revive_dinosaur():
	past_health.is_dead = health.is_dead
	$Sprites.play("default")
	#print("we are so back")

func exhausted_dino():
	past_stamina.is_exhausted = stamina.is_exhausted
	stamina.current_stamina = stamina.min_stamina
	out_of_stamina.emit()
	#print("eepy tired dino")

func un_exhausted_dino():
	past_stamina.is_exhausted = stamina.is_exhausted
	#print("wakey bakey")

#calling this sets the rotation and flip
func rotate_and_flip(rotation: float, is_flipped_h: bool, is_flipped_v: bool):
	$Sprites.set_rotation_degrees(rotation)
	$Sprites.flip_h = is_flipped_h
	$Sprites.flip_v = is_flipped_v

func get_sprite_size():
	return Vector2i(96,96)
