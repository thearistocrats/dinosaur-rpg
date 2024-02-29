#provides enums and classes for use in other scripts
#all methods here will be universal for all dinosaur

# i don't know enough about dinosaurs to fill this out, but add their species here
enum DinosaurTypes{
	NOTYPE,
	DEVIN,
	KEVIN,
	VELOCIRAPTOR,
	TRICERATOPS,
	TYRANNOSAURUS_REX
}

# these are just dnd5e dnmage types, replace with w/e
enum DamageTypes{
	ACID,
	BLUDGEONING,
	COLD,
	FIRE,
	FORCE,
	LIGHTNING,
	NECROTIC,
	PIERCING,
	POISON,
	PSYCHIC,
	RADIANT,
	SLASHING,
	THUNDER
}
enum Conditions{}
#tbd if we even need these
enum Spells{}
enum Items{}

enum Teams{
	PLAYER_TEAM,
	ENEMY_TEAM
}

enum TrackedStats{
	IDENTITY,
	HEALTH,
	STAMINA,
	ARMOR,
	ACTIONS,
	ATTACKS,
	TEAMS
}

static func get_variables():
	var instance = preload("res://scripts/dinosaur.gd")
	var vars_dict = {}
	for var_name in instance.get_instance_vars():
		vars_dict[var_name] = instance.new().get(var_name)
	return vars_dict

class Dinosaur:
	var actions = []
	var attacks = []
	var team: Teams
	
	
class Identity:
	var dino_name = "NO_NAME"
	var dino_type = DinosaurTypes.NOTYPE
	func set_stats(dino_name: String, dino_type: DinosaurTypes):
		self.dino_name = dino_name
		self.dino_type = dino_type
	func sync(other_class:Identity):
		set_stats(other_class.dino_name, other_class.dino_type)

class Health:
	var max_health = 100.0
	var starting_health = 100.0
	var min_health = 0.0
	var current_health = starting_health
	var is_dead = false
	func set_stats(max_health: float, starting_health: float, min_health: float, current_health: float, is_dead: bool):
		self.max_health = max_health
		self.starting_health = starting_health
		self.min_health = min_health
		self.current_health = current_health
		self.is_dead = is_dead
	func sync(other_class: Health):
		set_stats(other_class.max_health, other_class.starting_health, other_class.min_health, other_class.current_health, other_class.is_dead)
		#call this function to damage the dinosaur
	func damage_dinosaur(damage:float):
		if self.current_health <= self.min_health: pass
		var new_health = self.current_health - damage
		self.current_health = new_health if new_health >= self.min_health else self.min_health
	#call this function to heal the dinosaur
	func heal_dinosaur(heal_amount:float):
		if self.current_health >= self.max_health: pass
		var new_health = self.current_health + heal_amount
		self.current_health = new_health if new_health <= self.max_health else self.max_health
	#call this function to over damage the dinosaur
	func over_heal_dinosaur(heal_amount:float):
		self.current_health += heal_amount
	#call this function to over heal the dinosaur
	func over_damage_dinosaur(damage:float):
		self.current_health -= damage
	#call this function to fade overheal
	func over_heal_fade(fade_amount:float):
		if self.current_health <= self.max_health: pass
		var new_health = self.current_health - fade_amount
		self.current_health = new_health if self.new_health >= max_health else self.max_health

class Stamina:
	var max_stamina = 10
	var stamina_regen = 5
	var current_stamina = 10 
	var regen_before_turn = true
	var min_stamina = 0
	func set_stats(max_stamina: float, stamina_regen: float, current_stamina: float, regen_before_turn):
		self.max_stamina = max_stamina
		self.stamina_regen = stamina_regen
		self.current_stamina = current_stamina
		self.regen_before_turn = regen_before_turn
	func sync(other_class: Stamina):
		set_stats(other_class.max_stamina, other_class.stamina_regen, other_class.current_stamina, other_class.regen_before_turn)
		
	func regen_stamina(stamina_regen: int):
		if current_stamina >= max_stamina: pass
		var new_stamina = current_stamina + stamina_regen
		current_stamina = new_stamina if new_stamina <= max_stamina else max_stamina
		
	func reduce_stamina(cost: int):
		if current_stamina <= min_stamina: pass
		var new_stamina = current_stamina - cost
		current_stamina = new_stamina if new_stamina >= min_stamina else min_stamina

class Armor:
	var armour_flat = 0.0
	var armour_percent = 0.0
	func set_stats(armour_flat:float, armour_percent: float):
		self.armour_flat = armour_flat
		self.armour_percent = armour_percent
	func sync(other_class: Armor):
		set_stats(other_class.armour_flat, other_class.armour_percent)
		
	func calc_armor_negation(incoming_damage: float) -> float:
		if true: return (incoming_damage * (1.0 - self.armour_percent)) - self.armour_flat
		else: return (incoming_damage - self.armour_flat) * (1.0 - self.armour_percent)

class Attack:
	var damage: float
	var damage_type: DamageTypes
	var stamina_cost: int
	var uses_per_turn: int
	func _init(damage:float, damage_type:DamageTypes, stamina_cost:int):
		self.damage = damage
		self.damage_type = damage_type
		self.stamina_cost = stamina_cost

class Heal:
	var heal: float
	var is_over_heal: bool
	func _init(Heal: float, is_over_heal: bool):
		self.heal = heal
		self.is_over_heal = is_over_heal
