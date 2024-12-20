extends CharacterBody2D

@export var speed = 300.0  # Movement speed
@export var acceleration = 1500.0  # How quickly the character reaches max speed
@export var friction = 1000.0  # How quickly the character slows down
@export var dodge_speed = 800.0  # Speed during dodge
@export var dodge_duration = 0.3  # Duration of dodge
@export var dodge_cooldown = 1.0  # Cooldown between dodges

@export var max_health: int = 100
@export var attack_damage: int = 10  # Reduced damage from 20 to 10
@export var attack_range: float = 250.0  # Increased attack range
@export var chase_range: float = 400.0  # Slightly increased chase range

var health: int = max_health

# Dodge variables
var is_dodging = false
var dodge_timer = 0.0
var dodge_direction = Vector2.ZERO

# AI movement variables
var target = null
var wander_timer = 0.0
var wander_direction = Vector2.ZERO
var attack_timer = 0.0
var attack_cooldown: float = 1.5  # Increased cooldown for more strategic attacks

# Ability cooldowns
var ability_cooldowns: Dictionary = {}

@onready var health_bar = $EnemyHealthBar
@onready var health_label = $EnemyHealthBar/EnemyHealthLabel
@onready var attack_area = $AttackArea
@onready var detection_area = $DetectionArea

func _ready():
	# Add to enemy group
	add_to_group("enemy")
	
	# Initialize ability cooldowns
	ability_cooldowns = {
		"attack": 0,
		"dodge": 0
	}
	
	health_bar.max_value = max_health
	update_health_display()
	
	# Connect detection area signals
	detection_area.connect("body_entered", Callable(self, "_on_detection_area_body_entered"))
	detection_area.connect("body_exited", Callable(self, "_on_detection_area_body_exited"))
	
	# Connect attack area signals for additional debugging
	attack_area.connect("body_entered", Callable(self, "_on_attack_area_body_entered"))
	attack_area.connect("body_exited", Callable(self, "_on_attack_area_body_exited"))
	
	# Print attack area collision shape details
	var attack_area_shape = $AttackArea/EnemyAttackAreaCollisionShape
	print("Attack Area Position: ", attack_area_shape.position)
	print("Attack Area Scale: ", attack_area_shape.scale)

func update_cooldowns(delta):
	for ability in ability_cooldowns:
		if ability_cooldowns[ability] > 0:
			ability_cooldowns[ability] -= delta

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

func _physics_process(delta):
	# Update ability cooldowns
	update_cooldowns(delta)
	
	# Dodge logic
	if is_dodging:
		dodge_timer += delta
		velocity = dodge_direction * dodge_speed
		
		if dodge_timer >= dodge_duration:
			is_dodging = false
			dodge_timer = 0.0
	else:
		# AI movement logic
		if target:
			var distance_to_target = global_position.distance_to(target.global_position)
			print("Distance to target: %f" % distance_to_target)
			print("Attack range: %f" % attack_range)
			print("Chase range: %f" % chase_range)
			print("Attack cooldown: %f" % ability_cooldowns["attack"])
			
			# Decide behavior based on distance to target
			if distance_to_target <= attack_range:
				# Stop and attack
				velocity = Vector2.ZERO
				
				# Strategic attack with cooldown
				if ability_cooldowns["attack"] <= 0:
					print("Attempting to attack!")
					attack()
			elif distance_to_target <= chase_range:
				# Chase the target, but not directly into them
				var direction_to_target = (target.global_position - global_position).normalized()
				var approach_velocity = direction_to_target * speed * 0.7  # Slower approach
				
				# Slight zigzag to make movement less predictable
				var zigzag_offset = Vector2(sin(Time.get_ticks_msec() * 0.01), cos(Time.get_ticks_msec() * 0.01)) * 50
				velocity = approach_velocity + zigzag_offset
				
				# Try to dodge if close and health is low
				if distance_to_target < 150 and health < max_health / 2:
					if ability_cooldowns["dodge"] <= 0:
						dodge_towards_target()
			else:
				# Wander or idle when no target is in range
				wander_timer += delta
				if wander_timer >= 2.0:  # Change direction every 2 seconds
					wander_direction = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()
					wander_timer = 0.0
				
				velocity = velocity.move_toward(wander_direction * speed * 0.5, acceleration * delta)
	
	# Apply movement
	move_and_slide()

func take_damage(damage_amount):
	health -= damage_amount
	update_health_display()
	
	if health <= 0:
		die()

func die():
	print("Enemy died!")
	queue_free()

func attack():
	# Strategic attack with cooldown
	print("Enemy attack method called!")
	print("Attack Area Overlapping Bodies: %s" % attack_area.get_overlapping_bodies())
	
	# Find bodies in attack area
	var bodies = attack_area.get_overlapping_bodies()
	
	var attacked = false
	for body in bodies:
		print("Checking body: %s" % body)
		print("Is in player group: %s" % body.is_in_group("player"))
		print("Body global position: %s" % body.global_position)
		print("Enemy global position: %s" % global_position)
		print("Distance between enemy and body: %f" % global_position.distance_to(body.global_position))
		
		# Directly check for player
		if body.is_in_group("player"):
			# Explicitly deal damage
			var damage_to_deal = attack_damage
			print("ATTACKING PLAYER for %d damage!" % damage_to_deal)
			
			# Reduce player health directly
			body.health -= damage_to_deal
			body.update_health_display()
			
			# Check if player died
			if body.health <= 0:
				body.die()
			
			attacked = true
	
	# Reset attack cooldown only if an attack was performed
	if attacked:
		ability_cooldowns["attack"] = attack_cooldown
	else:
		print("No player found in attack area to damage!")

func dodge_towards_target():
	if ability_cooldowns["dodge"] > 0 or is_dodging or not target:
		return
	
	# Dodge in direction away from or perpendicular to target
	var direction_to_target = (target.global_position - global_position).normalized()
	dodge_direction = Vector2(-direction_to_target.y, direction_to_target.x)  # Perpendicular
	
	is_dodging = true
	ability_cooldowns["dodge"] = dodge_cooldown

func _on_detection_area_body_entered(body):
	if body.is_in_group("player"):
		target = body
		print("Player entered detection area!")

func _on_detection_area_body_exited(body):
	if body == target:
		target = null
		print("Player left detection area!")

func _on_attack_area_body_entered(body):
	print("Body entered attack area: %s" % body)
	print("Is in player group: %s" % body.is_in_group("player"))
	print("Body global position: %s" % body.global_position)
	print("Enemy global position: %s" % global_position)
	print("Distance between enemy and body: %f" % global_position.distance_to(body.global_position))

func _on_attack_area_body_exited(body):
	print("Body exited attack area: %s" % body)
