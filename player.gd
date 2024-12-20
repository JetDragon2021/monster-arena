extends CharacterBody2D

@export var speed = 300.0  # Movement speed
@export var acceleration = 1500.0  # How quickly the character reaches max speed
@export var friction = 1000.0  # How quickly the character slows down
@export var dodge_speed = 800.0  # Speed during dodge
@export var dodge_duration = 0.3  # Duration of dodge
@export var dodge_cooldown = 1.0  # Cooldown between dodges

# Camera tracking
@export var camera_follow_speed = 5.0  # Consistent camera tracking speed

# Monster-like attributes
@export var health: int = 100
@export var attack_damage: int = 10
@export var max_health: int = 100

# Ability cooldowns
var ability_cooldowns: Dictionary = {}

# Dodge variables
var is_dodging = false
var dodge_timer = 0.0
var dodge_direction = Vector2.ZERO

@onready var attack_area = $AttackArea
@onready var camera = $Camera2D
@onready var health_bar = $HealthBar
@onready var health_label = $HealthBar/HealthLabel

func _ready():
	# Initialize ability cooldowns
	ability_cooldowns = {
		"attack": 0,
		"clone": 0,
		"heal": 0,
		"dodge": 0,
		"rage": 0,
		"shield": 0,
		"poison": 0,
		"teleport": 0,
		"sacrifice": 0,
		"reflect": 0,
		"drain": 0,
		"berserk": 0,
		"time_warp": 0
	}
	
	# Initialize health bar
	health_bar.max_value = max_health
	update_health_display()

func _physics_process(delta):
	# Dodge logic
	if is_dodging:
		dodge_timer += delta
		velocity = dodge_direction * dodge_speed
		
		if dodge_timer >= dodge_duration:
			is_dodging = false
			dodge_timer = 0.0
	else:
		# Normal movement logic
		var input_vector = Vector2.ZERO
		input_vector.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
		input_vector.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
		input_vector = input_vector.normalized()
		
		# Apply movement
		if input_vector != Vector2.ZERO:
			velocity = velocity.move_toward(input_vector * speed, acceleration * delta)
		else:
			velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
	
	# Move the character and handle collisions
	var collision = move_and_collide(velocity * delta)
	
	# If collision occurs with an enemy, stop movement
	if collision:
		var collider = collision.get_collider()
		if collider.is_in_group("enemy"):
			velocity = Vector2.ZERO
	
	# Smooth camera tracking
	if camera:
		camera.global_position = global_position
	
	# Update ability cooldowns
	update_cooldowns(delta)
	
	# Check for attack input
	if Input.is_action_just_pressed("attack"):
		attack()
	
	# Check for dodge input
	if Input.is_action_just_pressed("dodge"):
		dodge()

func update_cooldowns(delta):
	for ability in ability_cooldowns:
		if ability_cooldowns[ability] > 0:
			ability_cooldowns[ability] -= delta

# Dodge ability
func dodge():
	if ability_cooldowns["dodge"] > 0 or is_dodging:
		return
	
	# Dodge in input direction
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	input_vector.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	
	# If no input, dodge in last movement direction
	if input_vector == Vector2.ZERO:
		input_vector = velocity.normalized()
	
	dodge_direction = input_vector
	is_dodging = true
	dodge_timer = 0.0
	ability_cooldowns["dodge"] = dodge_cooldown

# Basic attack ability
func attack():
	if ability_cooldowns["attack"] > 0:
		return
	
	# Find bodies in attack area
	var bodies = attack_area.get_overlapping_bodies()
	for body in bodies:
		if body.has_method("take_damage") and body != self:
			body.take_damage(attack_damage)
	
	# Set attack cooldown
	ability_cooldowns["attack"] = 0.5  # Half-second cooldown

func take_damage(amount: int):
	print("PLAYER TAKE DAMAGE CALLED!")
	print("Current Health Before Damage: ", health)
	print("Damage Amount: ", amount)
	
	health -= amount
	print("Current Health After Damage: ", health)
	
	# Update health display
	update_health_display()
	
	# Check for death
	if health <= 0:
		print("PLAYER DIED!")
		die()
	
	return true

func update_health_display():
	print("Updating Health Display")
	print("Health: ", health)
	print("Max Health: ", max_health)
	
	if health_bar:
		health_bar.value = health
		print("Health Bar Value Set To: ", health_bar.value)
	else:
		print("ERROR: Health Bar Not Found!")
	
	if health_label:
		health_label.text = "%d / %d" % [health, max_health]
		print("Health Label Text Set To: ", health_label.text)
	else:
		print("ERROR: Health Label Not Found!")

func die():
	print("PLAYER DIE METHOD CALLED!")
	health = max_health
	update_health_display()

# Universal Abilities
func clone():
	if ability_cooldowns["clone"] > 0:
		return
	# TODO: Implement clone logic
	ability_cooldowns["clone"] = 10.0  # 10-second cooldown

func heal(amount: int = 20):
	if ability_cooldowns["heal"] > 0:
		return
	health = min(health + amount, max_health)
	update_health_display()
	ability_cooldowns["heal"] = 5.0  # 5-second cooldown

func rage():
	if ability_cooldowns["rage"] > 0:
		return
	# TODO: Implement rage mode (increase damage, decrease defense)
	ability_cooldowns["rage"] = 10.0  # 10-second cooldown

func shield():
	if ability_cooldowns["shield"] > 0:
		return
	# TODO: Implement shield logic
	ability_cooldowns["shield"] = 8.0  # 8-second cooldown

func poison(target):
	if ability_cooldowns["poison"] > 0:
		return
	# TODO: Implement poison logic
	ability_cooldowns["poison"] = 6.0  # 6-second cooldown

func teleport():
	if ability_cooldowns["teleport"] > 0:
		return
	# TODO: Implement teleport logic
	ability_cooldowns["teleport"] = 5.0  # 5-second cooldown

func sacrifice(target):
	if ability_cooldowns["sacrifice"] > 0:
		return
	# TODO: Implement sacrifice logic
	ability_cooldowns["sacrifice"] = 15.0  # 15-second cooldown

func reflect():
	if ability_cooldowns["reflect"] > 0:
		return
	# TODO: Implement reflect logic
	ability_cooldowns["reflect"] = 10.0  # 10-second cooldown

func drain(target):
	if ability_cooldowns["drain"] > 0:
		return
	# TODO: Implement drain logic
	ability_cooldowns["drain"] = 7.0  # 7-second cooldown

func berserk():
	if ability_cooldowns["berserk"] > 0:
		return
	# TODO: Implement berserk mode
	ability_cooldowns["berserk"] = 20.0  # 20-second cooldown

func time_warp():
	if ability_cooldowns["time_warp"] > 0:
		return
	# TODO: Implement time warp (reset all cooldowns)
	ability_cooldowns["time_warp"] = 60.0  # 1-minute cooldown

func trigger_enemy_attack():
	# Find all enemies in the scene and force them to attack
	var enemies = get_tree().get_nodes_in_group("enemy")
	print("Triggering attack for enemies: ", enemies)
	
	for enemy in enemies:
		if enemy.has_method("attack"):
			print("Forcing enemy attack!")
			enemy.attack()
