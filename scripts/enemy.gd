extends CharacterBody2D

var speed = 50
var player_chase = false
var player = null
var last_dir = "none"

func _physics_process(delta):
	if player_chase:
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


func _on_detection_area_body_entered(body):
	player = body
	player_chase = true
	
func _on_detection_area_body_exited(body):
	player = null
	player_chase = false
