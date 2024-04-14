class Armor:
	var armour_flat = 0.0
	var armour_percent = 0.0
	#var ablative_armor = 0
	func set_stats(_armour_flat:float, _armour_percent: float):
		self.armour_flat = _armour_flat
		self.armour_percent = _armour_percent

	func sync(other_class: Armor):
		set_stats(other_class.armour_flat, other_class.armour_percent)
		
	func calc_armor_negation(incoming_damage: float) -> float:
		if true: return (incoming_damage * (1.0 - self.armour_percent)) - self.armour_flat
		else: return (incoming_damage - self.armour_flat) * (1.0 - self.armour_percent)
