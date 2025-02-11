extends Node2D

@onready var tile_map = {}

func _ready():
	var board_size = Vector2(5, 3)  # Adjust based on your board size (columns, rows)
	for y in range(1, board_size.y + 1):
		for x in range(1, board_size.x + 1):
			var tile_name = "%d_%d" % [x, y]
			var tile_path = "FfMapBigger/%s" % tile_name  # Create the string path
			var tile = get_node(tile_path)  # Retrieve the tile node
			
			tile_map[tile_name] = {
				"node": tile,
				"position": tile.position,
				}
	print(tile_map)  # Debugging: Check if all tiles are stored properly
