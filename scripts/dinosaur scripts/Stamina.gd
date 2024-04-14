class Stamina:
	var max_stamina = 10
	var min_stamina = 0
	var stamina_regen = 5
	var current_stamina = max_stamina 
	var regen_before_turn = true
	var is_exhausted = false
	
	func set_stats(_max_stamina: int, _min_stamina:int, _stamina_regen: int, _current_stamina: int, _regen_before_turn):
		max_stamina = _max_stamina
		min_stamina = _min_stamina
		stamina_regen = _stamina_regen
		current_stamina = _current_stamina
		regen_before_turn = _regen_before_turn
		is_exhausted = current_stamina <= min_stamina

	func sync(other_class: Stamina):
		set_stats(other_class.max_stamina, other_class.min_stamina, other_class.stamina_regen, other_class.current_stamina, other_class.regen_before_turn)

	func regen_stamina(stamina_regen: int):
		if current_stamina >= max_stamina: pass
		var new_stamina = current_stamina + stamina_regen
		current_stamina = new_stamina if new_stamina <= max_stamina else max_stamina
		is_exhausted = current_stamina <= min_stamina
		
	func reduce_stamina(cost: int):
		if current_stamina <= min_stamina: pass
		var new_stamina = current_stamina - cost
		current_stamina = new_stamina if new_stamina >= min_stamina else min_stamina
		is_exhausted = current_stamina <= min_stamina
