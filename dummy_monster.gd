extends CharacterBody2D

@export var max_health: int = 100
var health: int = max_health

@onready var health_bar = $HealthBar
@onready var health_label = $HealthBar/HealthLabel

func _ready():
	health_bar.max_value = max_health
	update_health_display()

func take_damage(amount: int):
	health -= amount
	update_health_display()
	
	if health <= 0:
		die()

func update_health_display():
	health_bar.value = health
	health_label.text = "%d / %d" % [health, max_health]

func die():
	queue_free()
