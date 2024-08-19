extends Node2D

@onready var player = $player

# Called when the node enters the scene tree for the first time.
func _ready():
	Dialogic.signal_event.connect(_on_dialogic_signal)
	
	if Dialogic.current_timeline != null:
		return
		
	Dialogic.start("timeline")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_dialogic_signal(argument:String):
	player.play_anim(0, argument, 0.3)
	#match argument:
		#"get_up":
			

func _on_animation_player_animation_finished(anim_name):
	pass#Global.in_cutscene = false
