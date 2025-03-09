extends Node2D

#each tile is 216x216 pixels
## TO DO:
## - Moveable Traders
## - Turn order
## - Win conditions!!!
## - Make mini-menu work again
## - Side menu animations again


var FriendlyGameBoardArray: Array = [ # this represents the game board from the POV of the player at the beginning of the game. The 0s represents empty spaces on the board
	[0, 0, 0, 0, 0],
	[0, 0, 0, 0, 0],
	[0, 0, 0, 0, 0],
	[0, 0, 0, 0, 0],
	[0, 0, 0, 0 ,0]
]

var EnemyGameBoardArray: Array = [ # this represents the game board from the POV of the enemy at the beginning of the game. The 0s represents empty spaces on the board
	[0, 0, 0, 0, 0],
	[0, 0, 0, 0, 0],
	[0, 0, 0, 0, 0],
	[0, 0, 0, 0, 0],
	[0, 0, 0, 0 ,0]
]

var TilesDict = {
	"1_1": [1, 1],
	"1_2": [1, 2],
	"1_3": [1, 3],
	"1_4": [1, 4],
	"1_5": [1, 5],
	"2_1": [2, 1],
	"2_2": [2, 2],
	"2_3": [2, 3],
	"2_4": [2, 4],
	"2_5": [2, 5],
	"3_1": [3, 1],
	"3_2": [3, 2],
	"3_3": [3, 3],
	"3_4": [3, 4],
	"3_5": [3, 5],
	"4_1": [4, 1],
	"4_2": [4, 2],
	"4_3": [4, 3],
	"4_4": [4, 4],
	"4_5": [4, 5],
	"5_1": [5, 1],
	"5_2": [5, 2],
	"5_3": [5, 3],
	"5_4": [5, 4],
	"5_5": [5, 5],
}

var PieceSelectionCheck = {
	"FfNormanFort": false,
	"FfNormanTrader": false,
	"FfNormanWall": false,
	"FfCelticFort": false,
	"FfCelticTrader": false,
	"FfCelticWall": false,
}

var FriendlyPieceNumberRef = { #describes what value each piece takes in the FriendlyGameBoardArray
	"FfCelticFort" = 1,
	"FfCelticTrader" = 2,
	"FfCelticWall" = 3,
	"FfNormanFort" = 3,
	"FfNormanTrader" = 3,
	"FfNormanWall" = 3
}
var EnemyPieceNumberRef = { #describes what value each piece takes in the EnemyGameBoardArray
	"FfCelticFort" = 3,
	"FfCelticTrader" = 3,
	"FfCelticWall" = 3,
	"FfNormanFort" = 1,
	"FfNormanTrader" = 2,
	"FfNormanWall" = 3
}

var PieceTextureDict = {
	"FfCelticFort": preload("res://Assets/Sprites/NewSprites/FF_CelticFort_Bright.png"),
	"FfCelticTrader": preload("res://Assets/Sprites/NewSprites/FF_CelticTrader_Bright.png"),
	"FfCelticWall": preload("res://Assets/Sprites/NewSprites/FF_Wall_Bright.png"),
	"FfNormanFort": preload("res://Assets/Sprites/NewSprites/FF_NormanFort_Bright.png"),
	"FfNormanTrader": preload("res://Assets/Sprites/NewSprites/FF_NormanTrader_Bright.png"),
	"FfNormanWall": preload("res://Assets/Sprites/NewSprites/FF_Wall_Bright.png")
}

var stylebox_dict = { # need to connect this to tile buttons
	"FfNormanFort": preload("res://Assets/Textures/StyleBoxes/FfNormanFort_SB.tres"),
	"FfNormanTrader": preload("res://Assets/Textures/StyleBoxes/FfNormanTrader_SB.tres"),
	"FfNormanWall": preload("res://Assets/Textures/StyleBoxes/FfNormanWall_SB.tres"),
	"FfCelticFort": preload("res://Assets/Textures/StyleBoxes/FfCelticFort_SB.tres"),
	"FfCelticTrader": preload("res://Assets/Textures/StyleBoxes/FfCelticTrader_SB.tres"),
	"FfCelticWall": preload("res://Assets/Textures/StyleBoxes/FfNormanWall_SB.tres"),
	"FfCelticTrader_Hover": preload("res://Assets/Textures/StyleBoxes/FfCelticTrader_Hover_SB.tres"),
	"FfNormanTrader_Hover": preload("res://Assets/Textures/StyleBoxes/FfNormanTrader_Hover_SB.tres")
}

var HoldingItem: bool = false
var SpriteFollowingMouse: Sprite2D = null
var turnordercount: int = 1

func _ready():
	## gets buttons in the button group, and connects the pressed signal with argument button
	for tilebutton in get_tree().get_nodes_in_group("TileButtons"):
		tilebutton.pressed.connect(Callable(self, "_on_tile_button_pressed").bind(tilebutton))
		
## gets buttons in the menupieces group and connects the pressed signal with argument menupiece
	for menupiece in get_tree().get_nodes_in_group("MenuPieces"):
		menupiece.pressed.connect(Callable(self, "_on_menupiece_button_pressed").bind(menupiece))
	
	for PieceSelectionKey in PieceSelectionCheck.keys(): # sets all pieces to be deselected on game start-up
		PieceSelectionCheck[PieceSelectionKey] = false
		
func turnorder():
	turnordercount += 1
	if turnordercount %2 == 0:
		print("it is the Celt's turn")
	else:
		print("it is the Norman's turn")
	

func _on_menupiece_button_pressed(menupiece): # true for all menu pieces, when menu piece selected
	UpdateBoardTextures()
	if HoldingItem == false: # only runs code if hand is empty
		print(menupiece.name, " pressed! Waiting for tile selection or discard") # debug - prints selected piece to console
		for Piece in PieceSelectionCheck: # loops through all pieces
			if PieceSelectionCheck.has(menupiece.name): # if the piece is valid
				PieceSelectionCheck[menupiece.name] = true # select that piece
				HoldingItem = true # set holding status to true, prevents multiple valid selections
			else:
				print(menupiece, " not found in dictionary") # debug, piece does not exist in the dictionary
	print(PieceSelectionCheck) # prints all pieces and whether they are selected or not (true/false)
	
func _input(event: InputEvent) -> void: #on right click, discard piece
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_RIGHT and SpriteFollowingMouse != null:
			SpriteFollowingMouse.queue_free() #kills the child
			for key in PieceSelectionCheck.keys():
				PieceSelectionCheck[key] = false #sets all pieces to not selected
			SpriteFollowingMouse = null #resets so there is no sprite attached to mouse
			HoldingItem = false
	
func _process(float) -> void:
	var mousepos : Vector2 = get_viewport().get_mouse_position()
	if HoldingItem == true and SpriteFollowingMouse == null:
		SpriteFollowingMouse = Sprite2D.new()
		for Piece in PieceSelectionCheck:
			if PieceSelectionCheck[Piece] == true:
				SpriteFollowingMouse.name = str(Piece) + "_following_mouse"
				#print(SpriteFollowingMouse.name) - debug, prints the name of the new child
				SpriteFollowingMouse.texture = PieceTextureDict[Piece] #sets the texture
				SpriteFollowingMouse.z_index = 5
				add_child(SpriteFollowingMouse)
	if SpriteFollowingMouse:
		SpriteFollowingMouse.position = mousepos
	
	

func _on_tile_button_pressed(tilebutton):
	UpdateBoardTextures()
	print("tile ", tilebutton.name, " selected") # debug - prints selected tile to console
	
	if HoldingItem == true: # only runs code if the player has a piece selected
		for Piece in PieceSelectionCheck: # runs through all pieces, and selects the piece that has been chosen from the piece menu
			if PieceSelectionCheck[Piece] == true:
				print (Piece, " placed on tile ", tilebutton.name) # debug - prints name of piece and tile it has been placed on to console
				
				var indices = TilesDict[tilebutton.name] # gets the [row,col] from dictionary of selected tile
				var row = int(indices[0]) - 1 # convert to 0-based index
				var col = int(indices[1]) - 1 # convert to 0-based index
				
				if row >= 0 and row < 5 and col >= 0 and col <5: #only runs if the index is valid
					UpdateBoardTextures()
					if turnordercount %2 == 0:
						tilebutton.set_meta("piece_type", "celt")

					else:
						tilebutton.set_meta("piece_type", "norman")
						
							
					if FriendlyGameBoardArray[row][col] == 0:
						FriendlyGameBoardArray[row][col] = FriendlyPieceNumberRef[Piece] # appends the piece number to the correct array location
						print("Updated Board: ", FriendlyGameBoardArray) # prints to console
						
						
						SpriteFollowingMouse.queue_free() # deletes piece attached to mouse
						SpriteFollowingMouse = null # resets sprite holder so another piece can be selected
						HoldingItem = false # allows another piece to be picked up
						UpdateBoardTextures()
						if Piece != "FfCelticWall" and Piece != "FfNormanWall":
							turnorder()
						
						for key in PieceSelectionCheck.keys():
							PieceSelectionCheck[key] = false #sets all pieces to not selected
					
					if EnemyGameBoardArray[row][col] == 0:
						EnemyGameBoardArray[row][col] = EnemyPieceNumberRef[Piece] # appends the piece number to the correct array location
						print("Updated Board: ", EnemyGameBoardArray) # prints to console
						#tilebutton.set_meta("piece_type", "celt")
						
						UpdateBoardTextures()
						
					else:
						print("tile: ", tilebutton, " already occupied!")
					
				else:
					print("Invalid tile indices:", row, col) # debug
					
		
		
func UpdateBoardTextures():
	for tile_name in TilesDict.keys(): #loops through tile button names in dict
		var indices = TilesDict[tile_name] # gets [row, col] from dictionary
		var row = int(indices[0]) - 1
		var col = int(indices[1]) - 1
		
		if row >= 0 and row < 5 and col >= 0 and col <5: # debug - prevents glitches from invalid indices
			var piece_number = FriendlyGameBoardArray[row][col] # gets the piece number from the array
			var enemy_piece_number = EnemyGameBoardArray[row][col]
			
			var piece_name = null
			var is_friendly = false
			
			if piece_number != 0:
				var tilebutton = get_node_or_null("FfMapBigger/%s" % tile_name)
				if tilebutton.get_meta("piece_type") == "norman": #only updates stylebox if there is a piece on the board
					for piece in FriendlyPieceNumberRef.keys(): # this chunk finds the piece name from the FriendlyPieceNumberRef
						if FriendlyPieceNumberRef[piece] == piece_number:
							piece_name = piece
							is_friendly = true
							break
					
				elif tilebutton.get_meta("piece_type") == "celt":
					for enemypiece in EnemyPieceNumberRef.keys():
						if EnemyPieceNumberRef[enemypiece] == enemy_piece_number:
							piece_name = enemypiece
							is_friendly = false
							break
				
				if piece_name and stylebox_dict.has(piece_name):
					var tile_button = get_node_or_null("FfMapBigger/%s" % tile_name) # Find the button by name
					if tile_button:
						tile_button.add_theme_stylebox_override("normal", stylebox_dict[piece_name])
						tile_button.add_theme_stylebox_override("hover", stylebox_dict[piece_name]) # changes stylebox of button
						print("Updated tile", tile_name, "with stylebox for ", piece_name)
