extends Node2D

var max_health: float
var current_health: float
var min_health: float
@export var health_bar_step_amount: float

#this only handles gui and texture elements, no health tracking or logic should be done here
#health bar texture itself is not original, pls replace it with something else,
#however if the sprites are lined up everything else should just work

func _ready():
	$Health_Bar_Texture.step = health_bar_step_amount

func set_health(new_max_health: float, new_current_health:float, new_min_health:float):
	max_health = new_max_health
	current_health = new_current_health
	min_health = new_min_health
	update_health_bar()

func update_current_health(new_current_health:float):
	current_health = new_current_health
	update_health_bar()

func update_max_health(new_max_health:float):
	max_health = new_max_health
	update_health_bar()

func update_min_health(new_min_health: float):
	min_health = new_min_health
	update_health_bar()

func update_health_bar():
	$Health_Numbers.text = str((current_health)) + "/" + str(int(max_health))
	$Health_Bar_Texture.value = current_health
	$Health_Bar_Texture.max_value = max_health
	$Health_Bar_Texture.min_value = min_health
