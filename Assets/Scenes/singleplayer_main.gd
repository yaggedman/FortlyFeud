extends Node2D

#declares tile map dictionary
@onready var tile_map = {}
var FriendlyPieceMenuRevealed : bool = true
var EnemyPieceMenuRevealed : bool = true


#creates dictionary for tile vector locations
func _ready():
	var board_size = Vector2(5, 5)  #adjust based on board size (columns, rows)
	for y in range(1, board_size.y + 1):
		for x in range(1, board_size.x + 1):
			var tile_name = "%d_%d" % [x, y]
			var tile_path = "FfMapBigger/%s" % tile_name  #creates the string path
			var tile = get_node(tile_path)  #retrieve the tile nodes
			
			tile_map[tile_name] = {
				"node": tile,
				"position": tile.position,
				}
	#print(tile_map)  #debugging - checks if all tiles are stored properly
	#below is example on how to access tile name and position
	print("Position of tile 3_5:", tile_map["3_5"]["position"])
	
	#declaring whether the side menus are revealed or not (revealed by default)
	FriendlyPieceMenuRevealed = true
	EnemyPieceMenuRevealed = true
	



#when the collapse button is pressed, collapse the piece selection menu
#friendly
func _on_piece_select_collapse_button_pressed() -> void:
	if FriendlyPieceMenuRevealed == false:
		#print("pressed and expanded")
		$FriendlyPieceselectpopup/CollapsePieceMenu.play("PieceSelectReveal")
		FriendlyPieceMenuRevealed = true
	else:
		#print("pressed and collapsed")
		$FriendlyPieceselectpopup/CollapsePieceMenu.play_backwards("PieceSelectReveal")
		FriendlyPieceMenuRevealed = false
		
#enemy
func _on_enemy_piece_select_collapse_button_pressed() -> void:
	if EnemyPieceMenuRevealed == false:
		#print("Pressed and expanded")
		$EnemyPieceselectpopup2/EnemyCollapsePieceMenu.play("EnemyPieceSelectReveal")
		EnemyPieceMenuRevealed = true
	else:
		#print("Pressed and collapsed")
		$EnemyPieceselectpopup2/EnemyCollapsePieceMenu.play_backwards("EnemyPieceSelectReveal")
		EnemyPieceMenuRevealed = false




#changes scale of piece in side menu, on hover
func _on_celtic_fort_area_2d_mouse_entered() -> void:
	$EnemyPieceselectpopup2/FfCelticFort.scale *= 1.2

func _on_celtic_fort_area_2d_mouse_exited() -> void:
	$EnemyPieceselectpopup2/FfCelticFort.scale /= 1.2
	

func _on_celtic_trader_area_2d_mouse_entered() -> void:
	$EnemyPieceselectpopup2/FfCelticTrader.scale *=1.2

func _on_celtic_trader_area_2d_mouse_exited() -> void:
	$EnemyPieceselectpopup2/FfCelticTrader.scale /=1.2


func _on_enemy_wall_area_2d_mouse_entered() -> void:
	$EnemyPieceselectpopup2/FfEnemyWall.scale *= 1.2

func _on_enemy_wall_area_2d_mouse_exited() -> void:
	$EnemyPieceselectpopup2/FfEnemyWall.scale /= 1.2


func _on_norman_fort_area_2d_mouse_entered() -> void:
	$FriendlyPieceselectpopup/FfNormanFort.scale *= 1.2

func _on_norman_fort_area_2d_mouse_exited() -> void:
	$FriendlyPieceselectpopup/FfNormanFort.scale /= 1.2


func _on_norman_trader_area_2d_mouse_entered() -> void:
	$FriendlyPieceselectpopup/FfNormanTrader.scale *= 1.2

func _on_norman_trader_area_2d_mouse_exited() -> void:
	$FriendlyPieceselectpopup/FfNormanTrader.scale /= 1.2


func _on_friendly_wall_area_2d_mouse_entered() -> void:
	$FriendlyPieceselectpopup/FfFriendlyWall.scale *= 1.2

func _on_friendly_wall_area_2d_mouse_exited() -> void:
	$FriendlyPieceselectpopup/FfFriendlyWall.scale /= 1.2
