extends CharacterBody2D

var player
var speed = 50
var pebbles_chase = false
var pebbles = null
var health = 250


	
func _physics_process(delta):
	update_health()
	if pebbles_chase:
		player = get_node("../Pebbles")
		position += (pebbles.position - position)/speed
		$AnimatedSprite2D.play("Idle")
		var direction = (player.position - self.position).normalized()
		if direction.x < 0:
			get_node("AnimatedSprite2D").flip_h = true
		else:
			get_node("AnimatedSprite2D").flip_h = false
		
		move_and_collide(Vector2.ZERO)

func _on_detection_radius_body_entered(body):
	if body.name == "Pebbles":
		pebbles = body
		pebbles_chase = true

func take_damage(damage: int) -> void:
	#take damage 
	health -= damage
	#if health reaches 0 then delete from scene
	if health <= 0:
		queue_free()

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

func _on_detection_radius_body_exited(body):
	pass
	
