class Stamina:
	var max_stamina = 10
	var min_stamina = 0
	var stamina_regen = 5
	var current_stamina = max_stamina 
	var regen_before_turn = true
	var out_of_stamina = false
	
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
