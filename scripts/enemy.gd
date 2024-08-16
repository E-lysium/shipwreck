extends CharacterBody2D

# enemy variables
var speed = 50
var player_chase = false
var player = null
var last_dir = "none"

var max_health = 100
var health = max_health
var player_in_attack_range = false
var can_take_damage = true

#add default anim

# enemy functionality
func _physics_process(delta):
	deal_with_damage()
	update_health()
	
	if player_chase and Global.player_health > 0:
		move_and_collide(Vector2(0,0))
		
		position += (player.position - position).normalized() * speed * delta
		
		if (player.position.x - position.x) < -10:
			enemy_move_anim("left")
		elif (player.position.x - position.x) > 10:
			enemy_move_anim("right")
		elif (player.position.y - position.y) < 0:
			enemy_move_anim("up")
		elif (player.position.y - position.y) > 0:
			enemy_move_anim("down")
	else: 
		enemy_idle_anim()


# enemy sprite animation
func enemy_move_anim(dir):
	var anim = $AnimatedSprite2D
	match dir:
		"left":
			anim.flip_h = true
			anim.play("walk_side")
			last_dir = "left"
		"right":
			anim.flip_h = false
			anim.play("walk_side")
			last_dir = "right"
		"down":
			anim.play("walk_down")
			last_dir = "down"
		"up":
			anim.play("walk_up")
			last_dir = "up"

func enemy_idle_anim():
	var anim = $AnimatedSprite2D
	match last_dir:
		"left":
			anim.flip_h = true
			anim.play("idle_side")
		"right":
			anim.flip_h = false
			anim.play("idle_side")
		"down":
			anim.play("idle_down")
		"up":
			anim.play("idle_up")
		_:
			anim.play("idle_side")


# enemy combat
func enemy():
	pass
	
func deal_with_damage():
	if player_in_attack_range and Global.player_current_attack:
		if can_take_damage:
			health = health - 10
			print("slime health = ", health)
			$take_damage_cooldown.start()
			can_take_damage = false
			
			if health <= 0:
				self.queue_free()

func _on_detection_area_body_entered(body):
	player = body
	player_chase = true
	
func _on_detection_area_body_exited(body):
	player = null
	player_chase = false

func _on_enemy_hitbox_body_entered(body):
	if body.has_method("player"):
		player_in_attack_range = true

func _on_enemy_hitbox_body_exited(body):
	if body.has_method("player"):
		player_in_attack_range = false

func _on_take_damage_cooldown_timeout():
	can_take_damage = true
	
	
# enemy health
func update_health():
	var healthbar = $healthbar
	
	healthbar.value = health
	
	if health >= max_health:
		healthbar.visible = false
	else:
		healthbar.visible = true
