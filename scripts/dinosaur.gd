#provides enums and classes for use in other scripts
#no logic or tracking will be done here
#maybe methods, but only for internal use

enum DinosaurTypes{# i don't know enough about dinosaurs to fill this out, but add their species here
	NOTYPE,
	DEVIN,
	KEVIN,
	VELOCIRAPTOR,
	TRICERATOPS,
	TYRANNOSAURUS_REX
}

enum DamageTypes{# these are just dnd5e dnmage types, replace with w/e
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

enum Spells{}
enum Items{}
enum Actions{
	ATTACK
}
enum Conditions{
	NONE
}

class Dinosaur:
	var dino_name: String
	var dino_type: DinosaurTypes
	
	var max_health: float
	var starting_health: float
	var min_health: float
	
	var armour_flat: float
	var armour_percent: float
	
	var attack_damage: float
	var damage_multiplier: float
	
	var healing_amount: float
	var over_healing_amount: float
	
	var current_health: float
	var is_alive: bool
	
	func _init(
		dino_name: String, dino_type: DinosaurTypes,
		max_health: float, starting_health: float, min_health: float,
		armour_flat: float, armour_percent: float,
		attack_damage: float, damage_multiplier: float,
		healing_amount: float, over_healing_amount: float
	):
		self.dino_name = dino_name
		self.dino_type = dino_type
		
		self.max_health = max_health
		self.starting_health = starting_health
		self.min_health = min_health
		
		self.armour_flat = armour_flat
		self.armour_percent = armour_percent
		
		self.attack_damage = attack_damage
		self.damage_multiplier = damage_multiplier
		
		self.healing_amount = healing_amount
		self.over_healing_amount = over_healing_amount
		
		self.current_health = starting_health
		self.is_dead = false
