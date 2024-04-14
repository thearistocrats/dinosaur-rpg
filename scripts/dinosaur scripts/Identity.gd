enum DinosaurTypes{
	NOTYPE,
	DEVIN,
	KEVIN,
	VELOCIRAPTOR,
	TRICERATOPS,
	TYRANNOSAURUS_REX
}

enum Teams{
	PLAYER_TEAM,
	ENEMY_TEAM
}

class Identity:
	var name = "NO_NAME"
	var type = DinosaurTypes.NOTYPE
	var team: Teams
	var position: Vector2i

	func set_stats(name: String, type: DinosaurTypes):
		self.name = name
		self.type = type

	func set_position(_position:Vector2i):
		self.position = _position
		self.team = _position.x
		
	func sync(other_class:Identity):
		set_stats(other_class.dino_name, other_class.dino_type)
		set_position(other_class.roster_position)
	
	func get_type_as_string() -> String:
		return DinosaurTypes.keys()[self.type]
	func get_team_as_string() -> String:
		return Teams.keys()[self.team]

