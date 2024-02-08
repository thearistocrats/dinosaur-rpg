#provides enums and classes for use in other scripts
#no logic or tracking will be done here
#maybe methods, but only for internal use

enum dinosaur_types{# i don't know enough about dinosaurs to fill this out, but add their species here
	DEVIN,
	KEVIN
}

enum damage_types{# these are just dnd5e dnmage types, replace with w/e
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

enum spells{}
enum items{}
enum moves{}

class starting_stats:
	var dino_type: dinosaur_types
	var max_health: float
	var starting_health: float
	var min_health: float
	var armour_flat: float
	var armour_percent: float
	var attack_damage: float
	var damage_multiplier: float
	var healing_amount: float
	var over_healing_amount: float
	
	func _init(
		new_dino_type: dinosaur_types,
		new_max_health: float,
		new_starting_health: float,
		new_min_health: float,
		new_armour_flat: float,
		new_armour_percent: float,
		new_attack_damage: float,
		new_damage_multiplier: float,
		new_healing_amount: float,
		new_over_healing_amount: float
	):
		dino_type = new_dino_type
		max_health = new_max_health
		starting_health = new_starting_health
		min_health = new_min_health
		armour_flat = new_armour_flat
		armour_percent = new_armour_percent
		attack_damage = new_attack_damage
		damage_multiplier = new_damage_multiplier
		healing_amount = new_healing_amount
		over_healing_amount = new_over_healing_amount

class current_state:
	var current_health: float
	var is_dead: bool
	
	func _init(
		new_current_health: float, 
		is_dead: bool
	):
		current_health = new_current_health
