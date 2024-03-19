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
	var dino_name = "NO_NAME"
	var dino_type = DinosaurTypes.NOTYPE
	var team: Teams
	var roster_position: Vector2i

	func set_stats(dino_name: String, dino_type: DinosaurTypes):
		self.dino_name = dino_name
		self.dino_type = dino_type

	func set_roster_position(roster_pointer:Vector2i):
		self.roster_position = roster_pointer
		self.team = Teams.keys()[roster_pointer.x]
		
	func sync(other_class:Identity):
		set_stats(other_class.dino_name, other_class.dino_type)
		set_roster_position(other_class.roster_position)

