extends CharacterBody2D

@export var health: int = 100
@export var attack_damage: int = 10

func take_damage(amount: int):
	health -= amount
	if health <= 0:
		die()

func die():
	queue_free()
