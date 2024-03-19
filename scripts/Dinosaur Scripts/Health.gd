class Health:
	var max_health = 100.0
	var min_health = 0.0
	var starting_health = max_health
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
