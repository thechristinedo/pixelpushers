extends CharacterBody2D

@export var bullet_scene: PackedScene


var player
var speed = 200
var pebbles_chase = false
var pebbles = null
var health = 250
var can_shoot = true

# Combat
var pebbles_inattack_zone = false
var can_take_damage = true

func _ready():
	$AnimatedSprite2D.connect("animation_finished", Callable(self, "_on_AnimatedSprite2D_animation_finished"))
	
func _physics_process(_delta):
	update_health()
	
	if pebbles_chase:
		player = get_node("../Pebbles")
		shoot_pebbles()
		position += (pebbles.position - position)/speed
		$AnimatedSprite2D.play("running")
		var direction = (player.position - self.position).normalized()
		if direction.x < 0:
			get_node("AnimatedSprite2D").flip_h = true
		else:
			get_node("AnimatedSprite2D").flip_h = false
		
		move_and_collide(Vector2.ZERO)
	else:
		$AnimatedSprite2D.play("Idle")
		

func _on_detection_radius_body_entered(body):
	if body.name == "Pebbles":
		pebbles = body
		pebbles_chase = true
		#shoot_pebbles()
		#CALL the shoot function here when he gets detected shoot_pebbles()

func take_damage(damage: int) -> void:
	#take damage 
	health -= damage
	#if health reaches 0 then delete from scene
	if health <= 0:
		$AnimatedSprite2D.play("death")  # Assumes the animation's name is "death"
		health = 0
		set_physics_process(false)  # Optional: stops other logic from processing during death animation
		await $AnimatedSprite2D.animation_finished
		#queue_free()

func update_health():
	var healthbar = $HealthBar
	healthbar.value = health
	
	if health >= 250:
		healthbar.visible = false
	else:
		healthbar.visible = true

func _on_regen_timer_timeout():
	if health < 250:
		health += 20
		if health > 250:
			health = 250
	
	if health <= 0:
		health = 0

func _on_detection_radius_body_exited(_body):
	pass
	
func fat_penguin_cop():
	pass
	
	
func shoot_pebbles():
	var bullet: Area2D = bullet_scene.instantiate()
	bullet.global_position = get_node("Shotgun/Muzzle").global_position
	bullet.look_at(player.global_position)  # Rotate the bullet towards the player's position
	bullet.rotation = get_node("Shotgun").rotation
	owner.add_child(bullet)
	can_shoot = false

func _on_take_damage_cooldown_timeout():
	can_take_damage = true

func _on_AnimatedSprite2D_animation_finished():
	if $AnimatedSprite2D.animation == "death":
		# Add any logic here that should run after the death animation completes
		queue_free()
