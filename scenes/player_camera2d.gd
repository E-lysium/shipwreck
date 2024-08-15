extends Camera2D

@export var tilemap: TileMap

# Called when the node enters the scene tree for the first time.
func _ready():
	var map_rect := tilemap.get_used_rect()
	var tile_size := tilemap.tile_set.tile_size
	var world_size := map_rect.size * tile_size
	
	limit_left = map_rect.position.x
	limit_top = map_rect.position.y
	limit_right = world_size.x
	limit_bottom = world_size.y


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
