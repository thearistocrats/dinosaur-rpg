#provides enums and classes for use in other scripts
#no logic or tracking will be done here
#maybe methods, but only for internal use

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
enum Conditions{
	NONE
}

#tbd if we even need these
enum Spells{}
enum Items{}
enum Actions{
	ATTACK
}

#these mirror the stats tracked below
enum TrackedStats{
	DINO_NAME,
	DINO_TYPE,
	MAX_HEALTH,
	STARTING_HEALTH,
	MIN_HEALTH,
	CURRENT_HEALTH,
	ARMOUR_FLAT,
	ARMOUR_PERCENT,
	ATTACK_DAMAGE,
	DAMAGE_MULTIPLIER,
	HEALING_AMOUNT,
	OVER_HEALING_AMOUNT,
	CURRENT_CONDITION,
	IS_DEAD,
	IS_FLIPPED_H,
	IS_FLIPPED_V,
	ROTATION
}

class Dinosaur:
	#either use @export to use the inspector to easily change variables or change it manually
	#provided are default values, do not change any values here as it will change the default for all dinosaurs, 
	#which may also get overwritten
	var dino_name = "NO NAME"
	var dino_type = DinosaurTypes.NOTYPE
	
	var max_health = 100.0
	var starting_health = 100.0
	var min_health = 0.0
	var current_health = starting_health
	
	var armour_flat = 0.0
	var armour_percent = 0.0
	
	var attack_damage = 35.0
	var damage_multiplier = 0.0
	
	var healing_amount = 15.0
	var over_healing_amount = 5.0
	
	var current_condition = Conditions.NONE
	
	var is_dead = false
	
	var is_flipped_h = false
	var is_flipped_v = false
	var rotation = 0.0
	
	#array for storing stats that are different for a current state and a past state
	var stats_to_act_on = []
	
	#takes another instance of the same class and uses it to set some stats
	func sync_all(other_class: Dinosaur):
		sync_identity(other_class)
		sync_health(other_class)
		sync_armor(other_class)
		sync_attack(other_class)
		sync_healing(other_class)
		sync_condition(other_class)
		sync_is_dead(other_class)
		sync_rotate_and_flip(other_class)
	func sync_identity(other_class: Dinosaur):
		self.dino_name = other_class.dino_name
		self.dino_type = other_class.dino_type
	func sync_health(other_class: Dinosaur):
		self.max_health = other_class.max_health
		self.starting_health = other_class.starting_health
		self.min_health = other_class.min_health
		self.current_health = other_class.current_health
	func sync_armor(other_class: Dinosaur):
		self.armour_flat = other_class.armour_percent
		self.armour_percent = other_class.armour_percent
	func sync_attack(other_class: Dinosaur):
		self.attack_damage = other_class.attack_damage
		self.damage_multiplier = other_class.damage_multiplier
	func sync_healing(other_class: Dinosaur):
		self.healing_amount = other_class.healing_amount
		self.over_healing_amount = other_class.over_healing_amount
	func sync_condition(other_class: Dinosaur):
		self.current_condition = other_class.current_condition
	func sync_is_dead(other_class: Dinosaur):
		self.is_dead = other_class.is_dead
	func sync_rotate_and_flip(other_class: Dinosaur):
		self.rotation = other_class.rotation
		self.is_flipped_h = other_class.is_flipped_h
		self.is_flipped_v = other_class.is_flipped_v
	
#use this to set the base stats for your dinosaur
	func populate_stats(
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
		self.current_condition = Conditions.NONE
	
	#these functions below are used to provide internal logic for the stats
	#these functions will be universal for all dinosaurs
	
	func calc_damage(incoming_damage:float) -> float:
		return (incoming_damage * (1.0 - self.armour_percent)) - self.armour_flat
		#return (incoming_damage - self.armour_flat) * (1.0 - self.armour_percent)
	
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
