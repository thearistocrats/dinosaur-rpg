extends Area2D
#loads the dinosaur script used to track stats for this dinosaur
const dinosaur = preload("res://Scripts/dinosaur.gd")
#loads enums from the dinosaur script, ideall i'd liked to do this automatiacally
const DinosaurTypes = dinosaur.DinosaurTypes
const DamageTypes = dinosaur.DamageTypes
const Conditions = dinosaur.Conditions
const TrackedStats = dinosaur.TrackedStats

#gets data from the inspector to make changing stats easier
@export_category("Dino data")
@export var _dinosaur_name: String
@export var _dinosaur_type: DinosaurTypes

@export_category("Health Numbers")
@export var _max_health: float
@export var _starting_health: float
@export var _min_health: float

@export_category("Armor Values")
@export var _armour_flat: float
@export var _armour_percent: float

@export_category("Damage Values")
@export var _attack_damage: float
@export var _damage_multiplier: float

@export_category("misc")
@export var _healing_amount: float
@export var _over_healing_amount: float

#@export var _rotation: float
#@export var _is_flipped_h: bool
#@export var _is_flipped_v: bool
#these will only be used to populate the dinosaur class, they are prefaced with _ because they are not to be used anywhere else
#the dinosaur script is to make it so we can make any dinosur interface with any other dinosuars

#all the stats are stored in devin
var devin = dinosaur.Dinosaur.new()
#past stats are also tracked, to ensure they are only done once
var past_state = dinosaur.Dinosaur.new()

#signals
signal dinosaur_hit
signal dinosaur_killed
signal attempt_attack(damage:float, attack_type: DinosaurTypes)

func _ready():
	#from here, please only use the variables in the dinosaur class devin, to unify tracked stats accross all dinosaurs
	devin.populate_stats(
		_dinosaur_name, _dinosaur_type, 
		_max_health, _starting_health, _min_health, 
		_armour_flat, _armour_percent, 
		_attack_damage, _damage_multiplier, 
		_healing_amount, _over_healing_amount
	)
	past_state.sync_all(devin)
	
	$"Button Panel/Name tag".text = devin.dino_name
	$Health_Bar.set_health(devin.max_health, devin.current_health, devin.min_health)
	$Devin_Sprite.play("default")

func _process(_delta):
	#currently using the _process function to check for changes
	build_stats_to_act_on_array()
	act_on_state()

#builds an array of stats to act on
func build_stats_to_act_on_array():
	update_stats()
	devin.stats_to_act_on = []
	
	#change the order to change the order of operations, however this doesnt really matter as its rare for more than one stat to be acted on at once
	if past_state.is_dead != devin.is_dead: devin.stats_to_act_on.append(TrackedStats.IS_DEAD)
	if past_state.rotation != devin.rotation: devin.stats_to_act_on.append(TrackedStats.ROTATION)
	if past_state.is_flipped_h != devin.is_flipped_h: devin.stats_to_act_on.append(TrackedStats.IS_FLIPPED_H)
	if past_state.is_flipped_v != devin.is_flipped_v: devin.stats_to_act_on.append(TrackedStats.IS_FLIPPED_V)
	if past_state.current_condition != devin.current_condition: devin.stats_to_act_on.append(TrackedStats.CURRENT_CONDITION)
	
	#if no changes, then it syncs all to the past state
	if devin.stats_to_act_on == []:
		past_state.sync_all(devin)

#use this to update any stats that wouldn't be updated elsewhere
func update_stats():
	devin.is_dead = devin.current_health <= devin.min_health

#loops through the array and acts on all the stats
func act_on_state():
	if devin.stats_to_act_on == []:
		return
	match devin.stats_to_act_on.pop_front():
		TrackedStats.IS_DEAD:
			kill_dinosaur() if devin.is_dead else revive_dinosaur()
		TrackedStats.ROTATION:
			rotate_and_flip(devin.rotation, devin.is_flipped_h, devin.is_flipped_v)
		TrackedStats.IS_FLIPPED_H:
			rotate_and_flip(devin.rotation, devin.is_flipped_h, devin.is_flipped_v)
		TrackedStats.IS_FLIPPED_V:
			rotate_and_flip(devin.rotation, devin.is_flipped_h, devin.is_flipped_v)
	build_stats_to_act_on_array()
	act_on_state()
	
#calling this kills the dinosaur
func kill_dinosaur():
	dinosaur_killed.emit()
	$Devin_Sprite.play("death_animation")
	devin.rotation = 90
	past_state.sync_is_dead(devin)
	print("ouch!")

#calling this revives the dinosaur
func revive_dinosaur():
	$Devin_Sprite.play("default")
	devin.rotation = 0
	past_state.sync_is_dead(devin)
	print("we are so back")

#calling this sets the rotation and flip
func rotate_and_flip(rotation: float, is_flipped_h: bool, is_flipped_v: bool):
	$Devin_Sprite.set_rotation_degrees(rotation)
	$Devin_Sprite.flip_h = is_flipped_h
	$Devin_Sprite.flip_v = is_flipped_v
	past_state.sync_rotate_and_flip(devin)
	
#these are leftovers from the button panel, which is only used for testing purposed rn and can be swaped out
func _on_attack():
	if !devin.is_dead:
		var damage_type = DamageTypes.BLUDGEONING
		attempt_attack.emit(devin.attack_damage, damage_type)
		print("pew pew!, attacking with ", str(devin.attack_damage), " of type ", str(damage_type))
		
func _on_self_damage():
	dinosaur_hit.emit()
	devin.damage_dinosaur(devin.attack_damage * devin.damage_multiplier)
	$Health_Bar.update_current_health(devin.current_health)
	
func _on_heal_self():
	devin.heal_dinosaur(devin.healing_amount)
	$Health_Bar.update_current_health(devin.current_health)
	
func _on_over_heal_self():
	devin.over_heal_dinosaur(devin.over_healing_amount)
	$Health_Bar.update_current_health(devin.current_health)
