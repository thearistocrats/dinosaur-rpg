extends Node2D

@export var base_dino_scene:PackedScene
@export var trexwithgun_scene:PackedScene

const map_icon = preload("res://gui/map/map_icon.tscn")
const trainer_script = preload("res://scripts/trainer scripts/Trainer.gd")
const dinosaur_script = preload("res://scripts/dinosaur scripts/Dinosaur.gd")
const Teams = dinosaur_script.Teams

var player = trainer_script.Trainer.new("player", true)
var beefstick = trainer_script.Trainer.new("beefstick", false)
var purple = trainer_script.Trainer.new("purple", false)
var trexwithguntrainer = trainer_script.Trainer.new("trexwithgun", false)
@onready var combat_screen = $"Combat Screen"

func _ready():
	beefstick.set_strategies(0,0,0,0)
	purple.set_strategies(0,0,0,0)
	trexwithguntrainer.set_strategies(0,2,0,0)
	
	start_encounter()

func start_encounter():
	var base_dino = base_dino_scene.instantiate()
	add_child(base_dino)
	player.add_dino_to_roster(base_dino)
	
	var trexwithgun = trexwithgun_scene.instantiate()
	add_child(trexwithgun)
	trexwithguntrainer.add_dino_to_roster(trexwithgun)
	
	
	combat_screen.populate_teams(player.roster, trexwithguntrainer.roster)
	
	combat_screen.setup_misc()
	combat_screen.start_encounter()
	combat_screen.show()
