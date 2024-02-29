extends Area2D
#loads the dinosaur script used to track stats for this dinosaur
const dinosaur_script = preload("res://Scripts/dinosaur.gd")
#loads enums from the dinosaur script, idealy i'd liked to do this automatiacally but this works for now
const DinosaurTypes = dinosaur_script.DinosaurTypes
const DamageTypes = dinosaur_script.DamageTypes
const Conditions = dinosaur_script.Conditions

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

@export_group("Damage Values")
@export var _attack_damage: float
@export var _damage_multiplier: float

@export_group("misc")
@export var _healing_amount: float
@export var _over_healing_amount: float

@export var _rotation: float
@export var _is_flipped_h: bool
@export var _is_flipped_v: bool
#these will only be used to populate the dinosaur class, they are prefaced with _ because they are not to be used anywhere else
#the dinosaur script is to make it so we can make any dinosur interface with any other dinosuars

var identity = dinosaur_script.Identity.new()
var health = dinosaur_script.Health.new()
var stamina = dinosaur_script.Stamina.new()
var armor = dinosaur_script.Armor.new()
var dinosaur = dinosaur_script.Dinosaur.new()

var past_health = dinosaur_script.Health.new()
var past_stamina = dinosaur_script.Stamina.new()

#var past_health = dinosaur_script.Health.new(health.get_variables())

#signals
signal dinosaur_hit
signal dinosaur_killed
signal attempt_attack(damage:float, attack_type: DinosaurTypes)
signal selected

#TEMP DELETE
var weak_attack = dinosaur_script.Attack.new(15, DamageTypes.SLASHING, 2)
var regular_attack = dinosaur_script.Attack.new(35, DamageTypes.BLUDGEONING, 3)
var bigfuckoffattack = dinosaur_script.Attack.new(75, DamageTypes.NECROTIC, 8)
var regular_healing = dinosaur_script.Heal.new(20, false)
var over_healing = dinosaur_script.Heal.new(10, true)

func _ready():
	identity.set_stats(_dinosaur_name, _dinosaur_type)
	health.set_stats(_max_health, _starting_health, _min_health, _max_health, false)
	stamina.set_stats(_max_stamina, _stamina_regen, _stamina_regen, _regen_before_turn)
	armor.set_stats(_armour_flat, _armour_percent)
	
	past_health.sync(health)
	past_stamina.sync(stamina)
	
	
#TEMP DELETE
	dinosaur.attacks.append(weak_attack)
	dinosaur.attacks.append(regular_attack)
	dinosaur.attacks.append(bigfuckoffattack)
	dinosaur.actions.append(regular_attack)
	dinosaur.actions.append(over_healing)
	
	$"Name tag".text = identity.dino_name
	$Health_Bar.set_health_bar(health, stamina)
	$Sprites.play("default")
	
func _process(_delta):
	update_stats()
	act_on_stat()
	
#use this to update any stats that wouldn't be updated elsewhere
func update_stats():
	health.is_dead = !(health.current_health > health.min_health)
	
func act_on_stat():
	if past_health.current_health != health.current_health:
		#func update_health_Bar(): this should be its own function but its fine here now
		$Health_Bar.update_health(health)
		past_health.current_health = health.current_health
	if past_stamina.current_stamina != stamina.current_stamina:
		#func update_health_Bar(): this should be its own function but its fine here now
		$Health_Bar.update_stamina(stamina)
		past_stamina.current_stamina = stamina.current_stamina
	if past_health.is_dead != health.is_dead: 
		kill_dinosaur() if health.is_dead else revive_dinosaur()
		
func _on_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton && event.pressed:
		selected.emit()
		print("click")
	
#calling this kills the dinosaur
func kill_dinosaur():
	health.is_dead = true
	past_health.is_dead = health.is_dead
	dinosaur_killed.emit()
	$Sprites.play("death_animation")
	print("ouch!")

#calling this revives the dinosaur
func revive_dinosaur():
	health.is_dead = false
	past_health.is_dead = health.is_dead
	$Sprites.play("default")
	print("we are so back")

#calling this sets the rotation and flip
func rotate_and_flip(rotation: float, is_flipped_h: bool, is_flipped_v: bool):
	$Sprites.set_rotation_degrees(rotation)
	$Sprites.flip_h = is_flipped_h
	$Sprites.flip_v = is_flipped_v
	
#these are leftovers from the button panel, which is only used for testing purposed rn and can be swaped out
func _on_attack():
	#REWORK REWORK REWORK REWORK
	var attack = dinosaur.actions[2]
	
	var stamina_cost = attack.stamina_cost
	var damage_type = attack.damage_type
	var attack_damage = attack.damage
	if !health.is_dead && stamina.current_stamina >= stamina_cost:
		attempt_attack.emit(attack_damage, damage_type)
		stamina.reduce_stamina(stamina_cost)
		print("pew pew!, attacking with ", str(attack_damage), " of type ", DamageTypes.keys()[damage_type])
		
func _on_self_damage():
	dinosaur_hit.emit()
	health.damage_dinosaur(_attack_damage)
	
func _on_heal_self():
	health.heal_dinosaur(_healing_amount)
	stamina.regen_stamina(stamina.stamina_regen)
	
func _on_over_heal_self():
	health.over_heal_dinosaur(_over_healing_amount)
	stamina.regen_stamina(stamina.stamina_regen)
