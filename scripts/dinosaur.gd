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

#tbd if we even need these
enum Spells{}
enum Items{}
enum Actions{
	ATTACK
}
enum Conditions{
	NONE
}

#this is used to track the state of the dinosaur, mostly for use to make sure methods based on state are only performed once
#anything that changes frequently, or changes how the dinosaur behaves should be tracked here
class State:
	#currently only if the dinosaur is dead is tracked, but we can add more things to track
	var is_dead: bool
	#syncs the variables, this method makes it clearer
	func sync_is_dead(is_dead: bool):
		self.is_dead = is_dead

#this class is used to track all stats for the dinosaur and provide useful functions
class Dinosaur:
	#either use @export to use the inspector to easily change variables or change it manually
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
	
	#these stats change often, unlike the stats above
	var current_health = starting_health
	var current_condition = Conditions.NONE
	
	#This is used to track the current state of the dinosaur, as well as its past state
	var past_state = State.new()
	var is_dead = false
	
#provided are some default values, all of which will be overwritten by calling this
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
		
		self.past_state.sync_is_dead(self.is_dead)
	
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
