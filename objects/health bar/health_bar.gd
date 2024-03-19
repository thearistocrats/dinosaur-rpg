extends Node2D

const dinosaur_script = preload("res://scripts/Dinosaur Scripts/Dinosaur.gd")
const health_script = dinosaur_script.health_script
const stamina_script = dinosaur_script.stamina_script
@export var health_bar_step_amount: float

#this only handles gui and texture elements, no health tracking or logic should be done here
#health bar texture itself is not original, pls replace it with something else,
#however if the sprites are lined up everything else should just work

func _ready():
	$Health_Bar_Texture.step = health_bar_step_amount
	
func set_health_bar(health: health_script.Health, stamina: stamina_script.Stamina):
	$Health_Bar_Texture.min_value = health.min_health
	$Health_Bar_Texture.max_value = health.max_health
	$Health_Bar_Texture.value = health.current_health
	$Health_Numbers.text = get_health_number_text(health)
	$Stamina_numbers.text = get_stamina_number_text(stamina)
	
func update_health(health: health_script.Health):
	$Health_Bar_Texture.min_value = health.min_health
	$Health_Bar_Texture.max_value = health.max_health
	$Health_Bar_Texture.value = health.current_health
	$Health_Numbers.text = get_health_number_text(health)

func update_stamina(stamina: stamina_script.Stamina):
	$Stamina_numbers.text = get_stamina_number_text(stamina)

func get_health_number_text(health: health_script.Health) -> String:
	return str(health.current_health) + "/" + str(int(health.max_health))

func get_stamina_number_text(stamina: stamina_script.Stamina) -> String:
	return "ST: " + str(stamina.current_stamina) + "/" + str(stamina.max_stamina)
