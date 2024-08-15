extends CharacterBody2D

# player variables
const speed = 100
var current_dir = "down"

var enemy_in_attack_range = false
var enemy_attack_cooldown = true
#var max_health = 200
#var health = max_health
var player_alive = true
var attack_in_progress = false

func _ready():
	$AnimatedSprite2D.play("front_idle")
	
	# camera functionality
	var tilemap_rect = get_parent().get_node("TileMap").get_used_rect() 
	var tilemap_cell_size = get_parent().get_node("TileMap").tile_set.tile_size 
	$Camera2D.limit_left = tilemap_rect.position.x * tilemap_cell_size.x
	$Camera2D.limit_right = tilemap_rect.end.x * tilemap_cell_size.x
	$Camera2D.limit_bottom = tilemap_rect.end.y * tilemap_cell_size.y
	$Camera2D.limit_top = tilemap_rect.position.y * tilemap_cell_size.y


# player functionality
func _physics_process(delta):
	if Global.player_health > 0:
		player_movement(delta)
		attack()
		enemy_attack()
		update_health()
	elif Global.player_health == 0:
		player_alive = false #add end screen here (back to menu, respawn, etc.)
		Global.player_health = -1
		print("player has been killed")
		$AnimatedSprite2D.play("death")
		#self.queue_free()
	
func player_movement(delta):
	if Input.is_action_pressed("ui_right"):
		current_dir = "right"
		play_anim(1, current_dir)
		velocity.x = speed
		velocity.y = 0
	elif Input.is_action_pressed("ui_left"):
		current_dir = "left"
		play_anim(1, current_dir)
		velocity.x = -speed
		velocity.y = 0
	elif Input.is_action_pressed("ui_down"):
		current_dir = "down"
		play_anim(1, current_dir)
		velocity.x = 0
		velocity.y = speed
	elif Input.is_action_pressed("ui_up"):
		current_dir = "up"
		play_anim(1, current_dir)
		velocity.x = 0
		velocity.y = -speed
	else:
		play_anim(0, current_dir)
		velocity.x = 0
		velocity.y = 0
	
	move_and_slide()	


# player sprite animation
func play_anim(movement, current_dir):
	var dir = current_dir
	var anim = $AnimatedSprite2D
	
	match dir:
		"right":
			anim.flip_h = false
			if movement == 1:
				anim.play("side_walk")
			elif movement == 0:
				if !attack_in_progress:
					anim.play("side_idle")
		"left":
			anim.flip_h = true
			if movement == 1:
				anim.play("side_walk")
			elif movement == 0:
				if !attack_in_progress:
					anim.play("side_idle")
		"up":
			if movement == 1:
				anim.play("back_walk")
			elif movement == 0:
				if !attack_in_progress:
					anim.play("back_idle")
		"down":
			if movement == 1:
				anim.play("front_walk")
			elif movement == 0:
				if !attack_in_progress:
					anim.play("front_idle")
		"death":
			anim.play("death")
		"getting_up":
			anim.play("getting_up")


# player combat
func player():
	pass
	
func attack():
	var dir = current_dir
	
	if Input.is_action_just_pressed("attack"):
		Global.player_current_attack = true
		attack_in_progress = true
		
		match dir:
			"right":
				$AnimatedSprite2D.flip_h = false
				$AnimatedSprite2D.play("side_attack")
				$deal_attack_timer.start()
			"left":
				$AnimatedSprite2D.flip_h = true
				$AnimatedSprite2D.play("side_attack")
				$deal_attack_timer.start()
			"down":
				$AnimatedSprite2D.play("front_attack")
				$deal_attack_timer.start()
			"up":
				$AnimatedSprite2D.play("back_attack")
				$deal_attack_timer.start()	

func enemy_attack():
	if enemy_in_attack_range and enemy_attack_cooldown:
		Global.player_health = Global.player_health - 10
		
		if Global.player_health < 0:
			Global.player_health = 0
			
		enemy_attack_cooldown = false
		$attack_cooldown.start()
		print(Global.player_health)

func _on_player_hitbox_body_entered(body):
	if body.has_method("enemy"):
		enemy_in_attack_range = true

func _on_player_hitbox_body_exited(body):
	if body.has_method("enemy"):
		enemy_in_attack_range = false

func _on_attack_cooldown_timeout():
	enemy_attack_cooldown = true

func _on_deal_attack_timer_timeout():
	$deal_attack_timer.stop()
	Global.player_current_attack = false
	attack_in_progress = false


# player health
func update_health():
	var healthbar = $healthbar
	healthbar.value = Global.player_health
	
	# not needed if health displayed as UI element
	# if UI element, Canvas node on player scene, health bar as child node
	if Global.player_health >= Global.max_player_health:
		healthbar.visible = false
	else:
		healthbar.visible = true

func _on_regen_timer_timeout():
	if Global.player_health < Global.max_player_health and Global.player_health > 0:
		Global.player_health = Global.player_health + 20
		if Global.player_health > Global.max_player_health:
			Global.player_health = Global.max_player_health
		print("current health = ", Global.player_health)
	#if Global.player_health <= 0:
		#Global.player_health = 0

