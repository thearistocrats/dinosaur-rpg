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

#this class is used to track all stats for the dinosaur and provide useful functions
#wip, state tracking for deaths or conditions
class Dinosaur:
	var dino_name = "NO NAME"
	var dino_type = DinosaurTypes.NOTYPE
	
	var max_health = 100.0
	var starting_health = 100.0
	var min_health = 0.0
	
	var armour_flat = 0.0
	var armour_percent = 0.0
	
	var attack_damage = 35.0
	var damage_multiplier = 0.0
	
	var healing_amount = 15.0
	var over_healing_amount = 5.0
	
	var current_health: float
	var is_alive: bool
	
#provided are some default values, all of which will be overwritten by calling this class constructor
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
	
	#call this function to damage the dinosaur
	func damage_dinosaur(damage:float):
		if self.current_health <= self.min_health:
			pass
		elif self.current_health - damage <= self.min_health:
			self.current_health = self.min_health
		else: self.current_health -= damage

	#call this function to heal the dinosaur
	func heal_dinosaur(heal_amount:float):
		if self.current_health >= self.max_health:
			pass
		elif self.current_health + heal_amount >= self.max_health:
			self.current_health = self.max_health
		else: self.current_health += heal_amount

	#call this function to over damage the dinosaur
	func over_heal_dinosaur(heal_amount:float):
		self.current_health += heal_amount
		
	#call this function to over heal the dinosaur
	func over_damage_dinosaur(damage:float):
		self.current_health -= damage

	#call this function to fade over heal the dinosaur
	func over_heal_fade(fade_amount:float):
		if self.current_health - fade_amount >= self.max_health:
			self.current_health -= fade_amount 
		elif self.current_health >= self.max_health:
			self.current_health = self.max_health
