extends CharacterBody2D

const max_speed = 400
const accel = 1500
const friction = 600

var input = Vector2.ZERO

func get_input():
	input.x = int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left"))
	input.y = int(Input.is_action_pressed("ui_down")) - int(Input.is_action_pressed("ui_up"))
	return input.normalized()
	
func player_movement(delta):
	input = get_input()
	
	if input === Vector2.ZERO:
		if velocity.length() > (friction * delta)
			velocity -= velocity.normalized()
