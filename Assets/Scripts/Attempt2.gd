extends Control

#each tile is 216x216 pixels
## TO DO:
## Enemy AI
## "Advance Turn" button. instead of automatic turn order
## undo/reset button when your turn
## on mobile, players cannot discard pieces after they have picked them. some kind of bin would work here.

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

var EnemyPieceNumberRef = { #describes what value each piece takes in the EnemyGameBoardArray
	"FfCelticFort" = 1,
	"FfCelticTrader" = 2,
	"FfCelticWall" = 4,
	"FfNormanFort" = 3,
	"FfNormanTrader" = 3,
	"FfNormanWall" = 4
}
var FriendlyPieceNumberRef = { #describes what value each piece takes in the FriendlyGameBoardArray
	"FfCelticFort" = 3,
	"FfCelticTrader" = 3,
	"FfCelticWall" = 4,
	"FfNormanFort" = 1,
	"FfNormanTrader" = 2,
	"FfNormanWall" = 4
}

var PieceTextureDict = {
	"FfCelticFort": preload("res://Assets/Sprites/20252405_FF_Colour Swap Sprites/FF_Fort_Norman_Red.png"),
	"FfCelticTrader": preload("res://Assets/Sprites/20252405_FF_Colour Swap Sprites/FF_Trader_Norman_Red.png"),
	"FfCelticWall": preload("res://Assets/Sprites/NewSprites/FF_Wall_Bright.png"),
	"FfNormanFort": preload("res://Assets/Sprites/20252405_FF_Colour Swap Sprites/FF_Fort_Celtic_Blue.png"),
	"FfNormanTrader": preload("res://Assets/Sprites/20252405_FF_Colour Swap Sprites/FF_Trader_Celtic_Red.png"),
	"FfNormanWall": preload("res://Assets/Sprites/NewSprites/FF_Wall_Bright.png")
}

var stylebox_dict = {
	"FfNormanFort": preload("res://Assets/Textures/StyleBoxes/FfNormanFort_SB.tres"),
	"FfNormanTrader": preload("res://Assets/Textures/StyleBoxes/FfNormanTrader_SB.tres"),
	"FfNormanWall": preload("res://Assets/Textures/StyleBoxes/FfNormanWall_SB.tres"),
	"FfCelticFort": preload("res://Assets/Textures/StyleBoxes/FfCelticFort_SB.tres"),
	"FfCelticTrader": preload("res://Assets/Textures/StyleBoxes/FfCelticTrader_SB.tres"),
	"FfCelticWall": preload("res://Assets/Textures/StyleBoxes/FfNormanWall_SB.tres"), # this uses the norman SB because I messed up the celtic one
	"FfCelticTrader_Hover": preload("res://Assets/Textures/StyleBoxes/FfCelticTrader_Hover_SB.tres"),
	"FfNormanTrader_Hover": preload("res://Assets/Textures/StyleBoxes/FfNormanTrader_Hover_SB.tres"),
	"FfWall_Left": preload("res://Assets/Textures/StyleBoxes/WALLLEFT_FfWall_SB.tres"),
	"FfWall_Right": preload("res://Assets/Textures/StyleBoxes/WALLRIGHT_FfWall_SB.tres"),
	"FfWall_Both": preload("res://Assets/Textures/StyleBoxes/WALLBOTH_FfWall_SB.tres")
}

var tacview_stylebox_dict = {
	"FfCelticFort": preload("res://Assets/Textures/StyleBoxes/TACVIEW_NormanFort.tres"),
	"FfCelticTrader": preload("res://Assets/Textures/StyleBoxes/TACVIEW_NormanTrader.tres"),
	"FfNormanFort": preload("res://Assets/Textures/StyleBoxes/TACVIEW_CelticFort.tres"),
	"FfNormanTrader": preload("res://Assets/Textures/StyleBoxes/TACVIEW_CelticTrader.tres"),
	"FfWall_Left": preload("res://Assets/Textures/StyleBoxes/TACVIEW_FfWallLeft.tres"),
	"FfWall_Right": preload("res://Assets/Textures/StyleBoxes/TACVIEW_FfWallRight.tres"),
	"FfWall_Both": preload("res://Assets/Textures/StyleBoxes/TACVIEW_FfWallBoth.tres"),
	"FfWall": preload("res://Assets/Textures/StyleBoxes/TACVIEW_FfWall.tres"),
}

var HoldingItem: bool = false
var SpriteFollowingMouse: Sprite2D = null
var turnordercount: int = 1
var FriendlyMenuShut = false
var EnemyMenuShut = false
var minimenushut = true
var tacticalview = false
var gamewon: bool = false
var gamelost: bool = false
var hoverpitch : float = 1
var suddendeathtoggle : bool = false
@export var is_multiplayer: bool = false

func _ready():
	randomize()
	
	if is_multiplayer:
		BotDifficulty = 2
		print("multiplayer selected, deactivating dumb bot.")
	
	else:
		BotDifficulty = 0
		print("singleplayer selected, activating dumb bot.")
		
	
	if OS.has_feature("pc") == false:
		$SmokeAnimation.play("blank")
	
	$"Background Waves".play()
	
	tacticalview = false
	$CeltVictory.visible = false
	
	$HammerAnimation.visible = false
	if OS.has_feature("windows") == true:
		$HammerAnimation.play("default")
	
	
	## gets buttons in the button group, and connects the pressed signal with argument button
	for tilebutton in get_tree().get_nodes_in_group("TileButtons"):
		tilebutton.set_meta("piece_type", "empty")
		tilebutton.pressed.connect(Callable(self, "_on_tile_button_pressed").bind(tilebutton))
		tilebutton.mouse_entered.connect(self._on_tile_button_hovered.bind(tilebutton))
	
	for menubutton in get_tree().get_nodes_in_group("MenuPieces"):
		menubutton.mouse_entered.connect(self._on_menu_button_hovered.bind(menubutton))
		
## gets buttons in the menupieces group and connects the pressed signal with argument menupiece
	for menupiece in get_tree().get_nodes_in_group("MenuPieces"):
		menupiece.pressed.connect(Callable(self, "_on_menupiece_button_pressed").bind(menupiece))
	
	for PieceSelectionKey in PieceSelectionCheck.keys(): # sets all pieces to be deselected on game start-up
		PieceSelectionCheck[PieceSelectionKey] = false
	
	for menubutton in get_tree().get_nodes_in_group("MenuButtons"):
		menubutton.mouse_entered.connect(self._on_mini_menu_button_hovered.bind(menubutton))
		
	print("it is the Norman's turn")
	$EnemyPieceselectpopup2/FfCelticFort.disabled = true
	$EnemyPieceselectpopup2/FfCelticTrader.disabled = true
	$FriendlyPieceselectpopup/FfNormanFort.disabled = false
	$FriendlyPieceselectpopup/FfNormanTrader.disabled = false
		
func turnorder(): # decides turn order, and disables buttons when it's not your turn
	LaneUpdates()
	turnordercount += 1
	
	if turnordercount %2 == 0:
		$"Dumb Bot Delay".start()
		print("it is the Celt's turn")
		$FriendlyPieceselectpopup/FfNormanFort.disabled = true
		$FriendlyPieceselectpopup/FfNormanTrader.disabled = true
		$EnemyPieceselectpopup2/FfCelticFort.disabled = false
		$EnemyPieceselectpopup2/FfCelticTrader.disabled = false
		for InventoryPiece in EnemyInventory:
			if InventoryPiece == "FfCelticWall" and EnemyInventory["FfCelticWall"] <= 0:
				$EnemyPieceselectpopup2/FfCelticWall.disabled = true
	else:
		print("it is the Norman's turn")
		$EnemyPieceselectpopup2/FfCelticFort.disabled = true
		$EnemyPieceselectpopup2/FfCelticTrader.disabled = true
		$FriendlyPieceselectpopup/FfNormanFort.disabled = false
		$FriendlyPieceselectpopup/FfNormanTrader.disabled = false
		for InventoryPiece in FriendlyInventory:
			if InventoryPiece == "FfNormanWall" and FriendlyInventory["FfNormanWall"] <= 0:
				$FriendlyPieceselectpopup/FfNormanWall.disabled = true

var FriendlyInventory = {
	"FfNormanWall" = 1
}

var EnemyInventory = {
	"FfCelticWall" = 2,
	"FfCelticTrader" = 999,
	"FfCelticFort" = 999
}

func _on_menupiece_button_pressed(menupiece): # true for all menu pieces, when menu piece selected
	UpdateBoardTextures()
	if HoldingItem == true: #if holding an item and another menu piece is selected
		SpriteFollowingMouse.queue_free() #kills the child
		for key in PieceSelectionCheck.keys():
			PieceSelectionCheck[key] = false #sets all pieces to not selected
			SpriteFollowingMouse = null #resets so there is no sprite attached to mouse
			HoldingItem = false
			
	if HoldingItem == false: # only runs code if hand is empty
		$PickUpPiece.play()
		print(menupiece.name, " pressed! Waiting for tile selection or discard") # debug - prints selected piece to console
		for Piece in PieceSelectionCheck: # loops through all pieces
			if PieceSelectionCheck.has(menupiece.name): # if the piece is valid
				if menupiece.name == "FfNormanTrader":
					
					for y in range(FriendlyGameBoardArray.size()):
						for x in range(FriendlyGameBoardArray[y].size()):
							if FriendlyGameBoardArray[y][x] == 2:
								var tile_name = str(y + 1) + "_" + str(x + 1)
								var tile_node = get_node_or_null("FfMapBigger/" + tile_name)
								print("trader found at ", tile_name, ", position is ", tile_node.global_position)
								$HammerAnimation.global_position = tile_node.global_position + Vector2(100,100)
								if OS.has_feature("windows") == true:
									$HammerAnimation.visible = true
								
				if menupiece.name == "FfCelticTrader":
					
					for y in range(EnemyGameBoardArray.size()):
						for x in range(EnemyGameBoardArray[y].size()):
							if EnemyGameBoardArray[y][x] == 2:
								var tile_name = str(y + 1) + "_" + str(x + 1)
								var tile_node = get_node_or_null("FfMapBigger/" + tile_name)
								print("trader found at ", tile_name, ", position is ", tile_node.global_position)
								$HammerAnimation.global_position = tile_node.global_position + Vector2(100,100)
								if OS.has_feature("windows"):
									$HammerAnimation.visible = true
								
				PieceSelectionCheck[menupiece.name] = true # select that piece
				HoldingItem = true # set holding status to true, prevents multiple valid selections
			else:
				print(menupiece, " not found in dictionary") # debug, piece does not exist in the dictionary
	#print(PieceSelectionCheck) # prints all pieces and whether they are selected or not (true/false)
	
func _input(event: InputEvent) -> void: #on right click, discard piece
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_RIGHT and SpriteFollowingMouse != null:
			
			if $HammerAnimation.visible == true:
				$HammerAnimation.visible = false
				
			SpriteFollowingMouse.queue_free() #kills the child
			for key in PieceSelectionCheck.keys():
				PieceSelectionCheck[key] = false #sets all pieces to not selected
			SpriteFollowingMouse = null #resets so there is no sprite attached to mouse
			HoldingItem = false
			#InvisibleCheck()
			
	if event is InputEventKey and event.pressed and event.keycode == KEY_ESCAPE:
		_on_mini_menu_button_pressed()
	
func _process(_float) -> void:
	#PlaceNewTrader() #debug
	#matrix_search() #debug
	var mousepos : Vector2 = get_global_mouse_position()
	if HoldingItem == true and SpriteFollowingMouse == null:
		SpriteFollowingMouse = Sprite2D.new()
		for Piece in PieceSelectionCheck:
			if PieceSelectionCheck[Piece] == true:
				SpriteFollowingMouse.name = str(Piece) + "_following_mouse"
				#print(SpriteFollowingMouse.name) - debug, prints the name of the new child
				SpriteFollowingMouse.texture = PieceTextureDict[Piece] #sets the texture
				if Piece != "FfCelticWall" and Piece != "FfNormanWall":
					SpriteFollowingMouse.z_index = 100
					SpriteFollowingMouse.scale = Vector2(8,8)
				add_child(SpriteFollowingMouse)
				if Piece == "FfCelticWall" or Piece == "FfNormanWall":
					SpriteFollowingMouse.z_index = 100
	if SpriteFollowingMouse:
		SpriteFollowingMouse.global_position = mousepos
		#print(SpriteFollowingMouse.name)

func _on_tile_button_pressed(tilebutton):
	LaneUpdates()
	
	
	tacticalview = true
	_on_tac_view_button_pressed()
	
	UpdateBoardTextures()
	print("tile ", tilebutton.name, " selected") # debug - prints selected tile to console 
	
	#if HoldingItem == false: #when no piece is selected from menu and tile is selected, run the moveable trader script
	#TraderMove(tilebutton)
		
	
	if HoldingItem == true: # only runs code if the player has a piece selected
		
		$PlacePieceOnBoard.play()
		
		for Piece in PieceSelectionCheck: # runs through all pieces, and selects the piece that has been chosen from the piece menu
			if PieceSelectionCheck[Piece] == true:
				print (Piece, " placed on tile ", tilebutton.name) # debug - prints name of piece and tile it has been placed on to console
				PlaceNewTrader()
				$SmokeAnimation.global_position = tilebutton.global_position + Vector2(100,100)
				if OS.has_feature("windows"):
					$SmokeAnimation.visible = true
					$SmokeAnimation.play("default")
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
						#print("Updated Friendly Board: ", FriendlyGameBoardArray) # prints to console
						
						if SpriteFollowingMouse != null:
							SpriteFollowingMouse.queue_free() # deletes piece attached to mouse
						SpriteFollowingMouse = null # resets sprite holder so another piece can be selected
						HoldingItem = false # allows another piece to be picked up
						UpdateBoardTextures()
						#InvisibleCheck()
						HoldingItem = false
						if Piece != "FfCelticWall" and Piece != "FfNormanWall":
							turnorder()
							
						if Piece == "FfCelticWall":
							EnemyInventory[Piece] -= 1
							for InventoryPiece in EnemyInventory:
								if InventoryPiece == "FfCelticWall" and EnemyInventory["FfCelticWall"] <= 0:
									$EnemyPieceselectpopup2/FfCelticWall.disabled = true
						
						if Piece == "FfNormanWall":
							FriendlyInventory[Piece] -= 1
							for InventoryPiece in FriendlyInventory:
								if InventoryPiece == "FfNormanWall" and FriendlyInventory["FfNormanWall"] <= 0:
									$FriendlyPieceselectpopup/FfNormanWall.disabled = true
							

						for key in PieceSelectionCheck.keys():
							PieceSelectionCheck[key] = false #sets all pieces to not selected
					
					if EnemyGameBoardArray[row][col] == 0:
					
						EnemyGameBoardArray[row][col] = EnemyPieceNumberRef[Piece] # appends the piece number to the correct array location
						#print("Updated Enemy Board: ", EnemyGameBoardArray) # prints to console
						#tilebutton.set_meta("piece_type", "celt")
						
						UpdateBoardTextures()
						#InvisibleCheck()
						for key in PieceSelectionCheck.keys():
							PieceSelectionCheck[key] = false #sets all pieces to not selected
						
					else:
						print("tile: ", tilebutton, " already occupied!")
					
				else:
					print("Invalid tile indices:", row, col) # debug
					
					
					
		LaneUpdates()
		boardfull()

func UpdateBoardTextures():
	LaneUpdates()
	#boardfull()
	
	if gamewon == true and gamelost != true:
		$CeltVictory.visible = true
	if gamewon != true and gamelost == true:
		$NormanVictory.visible = true
	if gamewon == true and gamelost == true:
		$NormanVictory.visible = false
		$CeltVictory.visible = false
		$"Draw Label".visible = true

			
	for tile_name in TilesDict.keys(): #loops through tile button names in dict
		
		#print("updating ", tile_name, " texture...") #debug message
		
		var tilebutton = get_node_or_null("FfMapBigger/%s" % tile_name)
		#var PieceMetaData = tilebutton.get_meta("piece_type")
		
		#print(tile_name, " meta data is ", PieceMetaData) #debug message
		
		var indices = TilesDict[tile_name] # gets [row, col] from dictionary
		var row = int(indices[0]) - 1
		var col = int(indices[1]) - 1
		
		if row >= 0 and row < 5 and col >= 0 and col <5: # debug - prevents glitches from invalid indices
			var piece_number = FriendlyGameBoardArray[row][col] # gets the piece number from the array
			var enemy_piece_number = EnemyGameBoardArray[row][col]
			
			var piece_name = null
			var _is_friendly = false
		
			if enemy_piece_number == 0:
				var new_stylebox = preload("res://Assets/Textures/StyleBoxes/FfEmpty.tres")
				var new_stylebox_hover = preload("res://Assets/Textures/StyleBoxes/FfEmptyHover.tres")
				tilebutton.add_theme_stylebox_override("normal", new_stylebox)
				tilebutton.add_theme_stylebox_override("hover", new_stylebox_hover)
				
			
			if piece_number == 4: #specifcally updates wall textures
				tilebutton.set_meta("piece_type", "wall")
				var connect_left = false
				var connect_right = false
				
				var directions = {
					"west": [0, -1],
					"east": [0, 1],
				}
				for dir in directions.keys():
					var new_row = row + directions[dir][0]
					var new_col = col + directions[dir][1]
					
					if new_row >= 0 and new_row <5 and new_col >= 0 and new_col < 5:
						var neighbour_value = FriendlyGameBoardArray[new_row][new_col]
						if neighbour_value == 4:
							if dir == "east":
								connect_right = true
							elif dir == "west":
								connect_left = true
				
				if tacticalview == false:
								
					if connect_left and connect_right:
						tilebutton.add_theme_stylebox_override("normal", stylebox_dict["FfWall_Both"])
						tilebutton.add_theme_stylebox_override("hover", stylebox_dict["FfWall_Both"])
					elif connect_left:
						tilebutton.add_theme_stylebox_override("normal", stylebox_dict["FfWall_Left"])
						tilebutton.add_theme_stylebox_override("hover", stylebox_dict["FfWall_Left"])
					elif connect_right:
						tilebutton.add_theme_stylebox_override("normal", stylebox_dict["FfWall_Right"])
						tilebutton.add_theme_stylebox_override("hover", stylebox_dict["FfWall_Right"])
					else:
						tilebutton.add_theme_stylebox_override("normal", stylebox_dict["FfNormanWall"])
						tilebutton.add_theme_stylebox_override("hover", stylebox_dict["FfNormanWall"])
				
				elif tacticalview == true:
													
					if connect_left and connect_right:
						tilebutton.add_theme_stylebox_override("normal", tacview_stylebox_dict["FfWall_Both"])
						tilebutton.add_theme_stylebox_override("hover", tacview_stylebox_dict["FfWall_Both"])
					elif connect_left:
						tilebutton.add_theme_stylebox_override("normal", tacview_stylebox_dict["FfWall_Left"])
						tilebutton.add_theme_stylebox_override("hover", tacview_stylebox_dict["FfWall_Left"])
					elif connect_right:
						tilebutton.add_theme_stylebox_override("normal", tacview_stylebox_dict["FfWall_Right"])
						tilebutton.add_theme_stylebox_override("hover", tacview_stylebox_dict["FfWall_Right"])
					else:
						tilebutton.add_theme_stylebox_override("normal", tacview_stylebox_dict["FfWall"])
						tilebutton.add_theme_stylebox_override("hover", tacview_stylebox_dict["FfWall"])
										
										
				
			if piece_number != 0 and piece_number !=4:
				#var tilebutton = get_node_or_null("FfMapBigger/%s" % tile_name)
				if tilebutton.get_meta("piece_type") == "norman": #if the tile button  is norman, use the friendly array
					for piece in FriendlyPieceNumberRef.keys(): # this chunk finds the piece name from the FriendlyPieceNumberRef
						if FriendlyPieceNumberRef[piece] == piece_number:
							piece_name = piece
							_is_friendly = true
							#print("piece is friendly!")
							break
					
				elif tilebutton.get_meta("piece_type") == "celt":
					for enemypiece in EnemyPieceNumberRef.keys():
						if EnemyPieceNumberRef[enemypiece] == enemy_piece_number:
							piece_name = enemypiece
							_is_friendly = false
							#print("piece is enemy!")
							break
				
				if piece_name and stylebox_dict.has(piece_name) and tacticalview == false:
					#var tile_button = get_node_or_null("FfMapBigger/%s" % tile_name) # Find the button by name
					if tilebutton:
						tilebutton.add_theme_stylebox_override("normal", stylebox_dict[piece_name])
						tilebutton.add_theme_stylebox_override("hover", stylebox_dict[piece_name]) # changes stylebox of button
						#print("Updated tile", tile_name, 	"with stylebox for ", piece_name)
				
				elif piece_name and tacview_stylebox_dict.has(piece_name) and tacticalview == true:
					if tilebutton:
						tilebutton.add_theme_stylebox_override("normal", tacview_stylebox_dict[piece_name])
						tilebutton.add_theme_stylebox_override("hover", tacview_stylebox_dict[piece_name]) # changes stylebox of button
						#print("Updated tile", tile_name, 	"with stylebox for ", piece_name)
						
			elif piece_number != 4 or enemy_piece_number !=4: #this sets stylebox of empty tiles, useful for when traders are picked up
				var new_stylebox = preload("res://Assets/Textures/StyleBoxes/FfEmpty.tres")
				var new_stylebox_hover = preload("res://Assets/Textures/StyleBoxes/FfEmptyHover.tres")
				tilebutton.add_theme_stylebox_override("normal", new_stylebox)
				tilebutton.add_theme_stylebox_override("hover", new_stylebox_hover)
				tilebutton.set_meta("piece_type", "empty")
				
	LaneUpdates()

func PlaceNewTrader():
	#if HoldingItem == true: # only runs code if the player has a piece selected
	for menupiece in PieceSelectionCheck:
			#print (menupiece)
		if PieceSelectionCheck[menupiece] == true and menupiece == ("FfCelticTrader"):
			print("Celtic Trader Selected")
			PieceSelectionCheck[menupiece] = false
			find_enemy_traders()
			
		elif PieceSelectionCheck[menupiece] == true and menupiece == ("FfNormanTrader"):
			print("Norman Trader Selected")
			PieceSelectionCheck[menupiece] = false
			find_friendly_traders()

func find_friendly_traders():
	for y in range(FriendlyGameBoardArray.size()):
		for x in range(FriendlyGameBoardArray[y].size()):
			if FriendlyGameBoardArray[y][x] == 2:
			
				var tile_name = str(y + 1) + "_" + str(x + 1)
				var tile_node = get_node_or_null("FfMapBigger/" + tile_name)
				print("trader found at ", tile_name, ", position is ", tile_node.global_position)
				$SmokeAnimation.global_position = tile_node.global_position + Vector2(100,100)
				if OS.has_feature("windows"):
					$SmokeAnimation.visible = true
				$SmokeAnimation.play("default")
				
				
				FriendlyGameBoardArray[y][x] = 0
				EnemyGameBoardArray[y][x] = 0
				UpdateBoardTextures()
				$HammerAnimation.visible = false

func find_enemy_traders():
	for y in range(EnemyGameBoardArray.size()):
		for x in range(EnemyGameBoardArray[y].size()):
			if EnemyGameBoardArray[y][x] == 2:
				EnemyGameBoardArray[y][x] = 0
				FriendlyGameBoardArray[y][x] = 0
				UpdateBoardTextures()
				$HammerAnimation.visible = false
				
				var tile_name = str(y + 1) + "_" + str(x + 1)
				var tile_node = get_node_or_null("FfMapBigger/" + tile_name)
				print("trader found at ", tile_name, ", position is ", tile_node.global_position)
				$SmokeAnimation.global_position = tile_node.global_position + Vector2(100,100)
				if OS.has_feature("windows"):
					$SmokeAnimation.visible = true
				$SmokeAnimation.play("default")

###################~MENU CODE~################################

func _on_piece_select_collapse_button_pressed() -> void: #on side menu button toggle, hide/show the piece side menu (friendly side)
	if FriendlyMenuShut == false:
		$FriendlyPieceselectpopup/CollapsePieceMenu.play_backwards("PieceSelectReveal")
		FriendlyMenuShut = true
		
	elif FriendlyMenuShut == true:
		$FriendlyPieceselectpopup/CollapsePieceMenu.play("PieceSelectReveal")
		FriendlyMenuShut = false
		
func _on_enemy_piece_select_collapse_button_pressed() -> void: #on side menu button toggle, hide/show the piece side menu (enemy side)
	if EnemyMenuShut == false:
		$EnemyPieceselectpopup2/EnemyCollapsePieceMenu.play_backwards("EnemyPieceSelectReveal")
		EnemyMenuShut = true
		
	elif EnemyMenuShut == true:
		$EnemyPieceselectpopup2/EnemyCollapsePieceMenu.play("EnemyPieceSelectReveal")
		EnemyMenuShut = false

func _on_mini_menu_button_pressed() -> void: #toggles mini menu (in the top right)
	if minimenushut == true:
		$Control2.visible = true
		for button in get_tree().get_nodes_in_group("TileButtons"):
			if button.get_meta("piece_type") == "empty":
				button.disabled = true
		minimenushut = false
		
	elif minimenushut == false:
		$Control2.visible = false
		for button in get_tree().get_nodes_in_group("TileButtons"):
			if button.get_meta("piece_type") == "empty":
				button.disabled = false
		minimenushut = true

func _on_mini_menu_resume_pressed() -> void: #toggles mini menu from the resume button in the mini menu
	if minimenushut == false:
		$Control2.visible = false
		minimenushut = true
		for button in get_tree().get_nodes_in_group("TileButtons"):
			if button.get_meta("piece_type") == "empty":
				button.disabled = false
	else:
		print("error: mini menu shut but resume button pressed!")

func _on_mini_menu_quit_pressed() -> void:
	if minimenushut == false:
		get_tree().change_scene_to_file("res://Assets/Scenes/main_menu.tscn")
	else:
		print("error: mini menu shut but quit button pressed!")

func _on_mini_menu_restart_pressed() -> void:
	if minimenushut == false and is_multiplayer != true:
		get_tree().reload_current_scene()
		
	elif minimenushut == false and is_multiplayer:
		var game_scene = preload("res://Assets/Scenes/SingleplayerMain.tscn")
		var game_instance = game_scene.instantiate()
		game_instance.is_multiplayer = true
	
		call_deferred("_switch_scene", game_instance)
	else:
		print("error: mini menu shut but restart button pressed!")
		
func _switch_scene(new_scene): ## when the game is multiplayer enabled, this handles restarting the game with is_multiplayer remaining true.
	var current_scene = get_tree().current_scene
	
	get_tree().root.add_child(new_scene)
	get_tree().current_scene = new_scene
	current_scene.queue_free()

###############TACTICAL VIEW###########################

func _on_tac_view_button_mouse_entered() -> void:
	$MiniMenuHover.play()
	

func _on_tac_view_button_pressed() -> void:
	LaneUpdates()
	if tacticalview == false:
		print("tactical view turned on")
		tacticalview = true
		$FfMapBigger/TacViewGreyOverlay.visible = true
		UpdateBoardTextures()
		
		for row in range(FriendlyGameBoardArray.size()):
			for col in range(FriendlyGameBoardArray.size()):
				if FriendlyGameBoardArray[row][col] == 2:
					print("Found a trader at: ", row, col)
					
					var directions = {
						"north": [-1, 0],
						"northeast": [-1, 1],
						"southeast": [1, 1],
						"south": [1, 0],
						"southwest":[1, -1],
						"west": [0, -1],
						"northwest": [-1, -1],
						"east": [0, 1],
					}
					for dir in directions.keys():
						var new_row = row + directions[dir][0]
						var new_col = col + directions[dir][1]
						var new_row2 = new_row + directions[dir][0]
						var new_col2 = new_col + directions[dir][1]
						
						if new_row >= 0 and new_row < 5 and new_col >= 0 and new_col < 5 and new_row2 >= 0 and new_row2 < 5 and new_col2 >= 0 and new_col2 < 5:
							var neighbour_value = FriendlyGameBoardArray[new_row][new_col]
							var piecejumpedto = FriendlyGameBoardArray[new_row2][new_col2]
							if neighbour_value == 3 and piecejumpedto == 1 or neighbour_value == 4 and piecejumpedto == 1: # if piece is able to be "jumped over" by trader
								
								
								var original = $TraderGuideAnimation
								var clone = original.duplicate()
								add_child(clone)
								
								clone.name = "TraderGuideClone" + str(Time.get_ticks_usec())
								clone.add_to_group("Clone_Group")
								
								#print("Value to the ", dir, " of trader is: ", neighbour_value)
							
								var tile_name = str(new_row + 1) + "_" + str(new_col + 1)
								var tile_node = get_node_or_null("FfMapBigger/" + tile_name)
								#print(neighbour_value, " position is ", tile_node.global_position, " ", tile_name)
								clone.global_position = tile_node.global_position + Vector2(108,104)
								if dir == "north":
									clone.play("default")
									clone.rotation_degrees = 0.0
								if dir == "east":
									clone.play("default")
									clone.rotation_degrees = 90.0
								if dir == "west":
									clone.play("default")
									clone.rotation_degrees = 270.0
								if dir == "south":
									clone.play("default")
									clone.rotation_degrees = 180.0
								if dir == "northeast":
									clone.play("friendlydiagonal")
									clone.global_position = tile_node.global_position + Vector2(108,103)
									clone.rotation_degrees = 0.0
								if dir == "southeast":
									clone.play("friendlydiagonal")
									clone.global_position = tile_node.global_position + Vector2(113,108)
									clone.rotation_degrees = 90.0
								if dir == "southwest":
									clone.play("friendlydiagonal")
									clone.global_position = tile_node.global_position + Vector2(109,114)
									clone.rotation_degrees = 180.0
								if dir == "northwest":
									clone.play("friendlydiagonal")
									clone.global_position = tile_node.global_position + Vector2(104,109)
									clone.rotation_degrees = 270.0
								clone.visible = true
								clone.z_index = 4
								clone.frame = 0
								
							
						else:
							print("No value to the ", dir, " out of bounds")
								
		
		for row in range(EnemyGameBoardArray.size()):
			for col in range(EnemyGameBoardArray.size()):
				if EnemyGameBoardArray[row][col] == 2:
					print("Found a trader at: ", row, col)
					
					var directions = {
						"north": [-1, 0],
						"northeast": [-1, 1],
						"southeast": [1, 1],
						"south": [1, 0],
						"southwest":[1, -1],
						"west": [0, -1],
						"northwest": [-1, -1],
						"east": [0, 1],
					}
					for dir in directions.keys():
						var new_row = row + directions[dir][0]
						var new_col = col + directions[dir][1]
						var new_row2 = new_row + directions[dir][0]
						var new_col2 = new_col + directions[dir][1]
						
						if new_row >= 0 and new_row < 5 and new_col >= 0 and new_col < 5 and new_row2 >= 0 and new_row2 < 5 and new_col2 >= 0 and new_col2 < 5:
							var neighbour_value = EnemyGameBoardArray[new_row][new_col]
							var piecejumpedto = EnemyGameBoardArray[new_row2][new_col2]
							if neighbour_value == 3 and piecejumpedto == 1 or neighbour_value == 4 and piecejumpedto == 1: # if piece is able to be "jumped over" by trader
								var original = $EnemyTraderGuideAnimation
								var clone = original.duplicate()
								add_child(clone)
								
								clone.name = "TraderGuideClone" + str(Time.get_ticks_usec())
								clone.add_to_group("Clone_Group")
								
								#print("Value to the ", dir, " of trader is: ", neighbour_value)
							
								var tile_name = str(new_row + 1) + "_" + str(new_col + 1)
								var tile_node = get_node_or_null("FfMapBigger/" + tile_name)
								#print(neighbour_value, " position is ", tile_node.global_position, " ", tile_name)
								clone.global_position = tile_node.global_position + Vector2(108, 108)
								if dir == "north":
									clone.play("default")
									clone.rotation_degrees = 0.0
								if dir == "east":
									clone.play("default")
									clone.rotation_degrees = 90.0
								if dir == "west":
									clone.play("default")
									clone.rotation_degrees = 270.0
								if dir == "south":
									clone.play("default")
									clone.rotation_degrees = 180.0
								if dir == "northeast":
									clone.play("enemydiagonal")
									clone.global_position = tile_node.global_position + Vector2(108,103)
									clone.rotation_degrees = 0.0
								if dir == "southeast":
									clone.play("enemydiagonal")
									clone.global_position = tile_node.global_position + Vector2(113,108)
									clone.rotation_degrees = 90.0
								if dir == "southwest":
									clone.play("enemydiagonal")
									clone.global_position = tile_node.global_position + Vector2(109,114)
									clone.rotation_degrees = 180.0
								if dir == "northwest":
									clone.play("enemydiagonal")
									clone.global_position = tile_node.global_position + Vector2(104,109)
									clone.rotation_degrees = 270.0
								clone.visible = true
								clone.z_index = 4
								clone.frame = 0
								
							
						else:
							print("No value to the ", dir, " out of bounds")
		
		
	elif tacticalview == true:
		for node in get_tree().get_nodes_in_group("Clone_Group"):
			node.queue_free()
		print("tacitcal view turned off")
		tacticalview = false
		$FfMapBigger/TacViewGreyOverlay.visible = false
		UpdateBoardTextures()
		print("Children count: ", $TraderGuideAnimation.get_child_count())

## ==================================WINCONDITIONS=====================================================
## ====================================================================================================

var FriendlyRows = {}
var FriendlyColumns = {}
var FriendlyDiagonals = {}
var EnemyRows = {}
var EnemyColumns = {}
var EnemyDiagonals = {}

var FriendlySize = FriendlyGameBoardArray.size()
var EnemySize = EnemyGameBoardArray.size()

func LaneUpdates() -> void:
	
	#print(FriendlyDiagonals) ## this is working but it is one turn delayed...
	
	var friendly_num_rows = FriendlyGameBoardArray.size()
	var friendly_num_cols = FriendlyGameBoardArray[0].size()
	var enemy_num_rows = EnemyGameBoardArray.size()
	var enemy_num_cols = EnemyGameBoardArray[0].size()
	
#########FRIENDLY ROWS############
	for i in friendly_num_rows:
		var row_label = "Row %d" % (i + 1)
		FriendlyRows[row_label] = FriendlyGameBoardArray[i]
	
	for col_index in friendly_num_cols:
		var col_label = "Column %d" % (col_index +1)
		var column_values = []
		
#########FRIENDLY COLUMNS##########
		for row_index in friendly_num_rows:
			column_values.append(FriendlyGameBoardArray[row_index][col_index])
		FriendlyColumns[col_label] = column_values
		
		
#########ENEMY ROWS############
	for i in enemy_num_rows:
		var row_label = "Row %d" % (i + 1)
		EnemyRows[row_label] = EnemyGameBoardArray[i]
		
#########ENEMY COLUMNS############
	for col_index in enemy_num_cols:
		var col_label = "Column %d" % (col_index +1)
		var column_values = []
		
		for row_index in enemy_num_rows:
			column_values.append(EnemyGameBoardArray[row_index][col_index])
		EnemyColumns[col_label] = column_values
		
#######FRIENDLY DIAGONALS##########

	var friendlysize = FriendlyGameBoardArray.size()
	
	
	#print(EnemyColumns)
		
	var friendlydiag_tl_br = [] ## top left to bottom right
	var friendlydiag_tr_bl = [] ## top right to bottom left

	for i in friendlysize:
		friendlydiag_tl_br.append(FriendlyGameBoardArray[i][i])
		friendlydiag_tr_bl.append(FriendlyGameBoardArray[i][friendlysize - 1 - i])
	FriendlyDiagonals["Diagonal TL-BR"] = friendlydiag_tl_br
	FriendlyDiagonals["Diagonal TR-BL"] = friendlydiag_tr_bl
	
	#######FRIENDLY OFFSET DIAGONALS#######################
	
	var friendlydiag_b1_e4 = []
	for i in range(friendlysize - 1):
		friendlydiag_b1_e4.append(FriendlyGameBoardArray[i][i + 1])
	FriendlyDiagonals["Diagonal B1-E4"] = friendlydiag_b1_e4
	
	var friendlydiag_a2_d5 = []
	for i in range(friendlysize - 1):
		friendlydiag_a2_d5.append(FriendlyGameBoardArray[i + 1][i])
	FriendlyDiagonals["Diagonal A2-D5"] = friendlydiag_a2_d5
	
	var friendlydiag_d1_a4 = []
	for i in range(friendlysize - 1):
		friendlydiag_d1_a4.append(FriendlyGameBoardArray[i][friendlysize - 2 - i])
	FriendlyDiagonals["Diagonal D1-A4"] = friendlydiag_d1_a4
	
	var friendlydiag_e2_b5 = []
	for i in range(friendlysize - 1):
		friendlydiag_e2_b5.append(FriendlyGameBoardArray[i + 1][friendlysize - 1 - i])
	FriendlyDiagonals["Diagonal E2-B5"] = friendlydiag_e2_b5
	
	#######ENEMY DIAGONALS##########

	var enemysize = EnemyGameBoardArray.size()
	var enemydiag_tr_bl = []
	var enemydiag_tl_br = []
	
	for i in enemysize:
		enemydiag_tl_br.append(EnemyGameBoardArray[i][i])
		enemydiag_tr_bl.append(EnemyGameBoardArray[i][enemysize - 1 - i])
	EnemyDiagonals["Diagonal TL-BR"] = enemydiag_tl_br
	EnemyDiagonals["Diagonal TR-BL"] = enemydiag_tr_bl
	
	#######ENEMY OFFSET DIAGONALS#######################
	
	var enemydiag_b1_e4 = []
	for i in range(enemysize - 1):
		enemydiag_b1_e4.append(EnemyGameBoardArray[i][i + 1])
		EnemyDiagonals["Diagonal B1-E4"] = enemydiag_b1_e4
	
	var enemydiag_a2_d5 = []
	for i in range(enemysize - 1):
		enemydiag_a2_d5.append(EnemyGameBoardArray[i + 1][i])
		EnemyDiagonals["Diagonal A2-D5"] = enemydiag_a2_d5
	
	var enemydiag_d1_a4 = []
	for i in range(enemysize - 1):
		enemydiag_d1_a4.append(EnemyGameBoardArray[i][enemysize - 2 - i])
		EnemyDiagonals["Diagonal D1-A4"] = enemydiag_d1_a4
	
	var enemydiag_e2_b5 = []
	for i in range(enemysize - 1):
		enemydiag_e2_b5.append(EnemyGameBoardArray[i + 1][enemysize - 1 - i])
		EnemyDiagonals["Diagonal E2-B5"] = enemydiag_e2_b5
		
		
	for key in FriendlyRows.keys():
		if check_lane_for_win(FriendlyRows[key]):
			print("Win in ", key)
			gamewon = true

	for key in FriendlyColumns.keys():
		if check_lane_for_win(FriendlyColumns[key]):
			print("Win in ", key)
			gamewon = true

	for key in FriendlyDiagonals.keys():
		if check_lane_for_win(FriendlyDiagonals[key]):
			print("Win in ", key)
			gamewon = true
	
	for key in EnemyRows.keys():
		if check_lane_for_win(EnemyRows[key]):
			print("Win in ", key)
			gamelost = true
	
	for key in EnemyColumns.keys():
		if check_lane_for_win(EnemyColumns[key]):
			print("Win in ", key)
			gamelost = true
			
	for key in EnemyDiagonals.keys():
		if check_lane_for_win(EnemyDiagonals[key]):
			print("Win in ", key)
			gamelost = true
			

func check_lane_for_win(lane: Array) -> bool:
	
	
	if lane.size() == 4:
		for piece in lane:
			if piece != 1 and piece != 2:
				return false
		return true # all numbers are valid, you win
		
	
	
	
	
	elif lane.size() == 5:
		for start in range(0, 2):
			var score = 0
			var i = start
			
			while i < lane.size():
				var piece = lane[i]
		
				if piece == 1:
					score += 1
					i += 1
		
				elif piece == 2:
					score += 1
					i += 1
					if i < lane.size() and (lane[i] == 3 or lane[i] == 4):
						i += 1
				
				elif piece == 3 or piece == 4:
					if i + 1 < lane.size() and lane[i + 1] == 2:
						score += 1
						i += 2
					else:
						score = 0
						break #blocked by a wall or enemy piece
				else:
					score = 0
					break # space is a 0 or invalid
		
				if score >=4:
					return true
			
	return false

#######################################SUDDEN DEATH#####################################################

func boardfull() -> void:
	var numberofpiecesonboard: int = 0
	numberofpiecesonboard = 0
	for y in range(FriendlyGameBoardArray.size()):
		for x in range(FriendlyGameBoardArray[y].size()):
			if FriendlyGameBoardArray[y][x] != 0:
				numberofpiecesonboard += 1
				if numberofpiecesonboard == 25:
					print("board fulL! destroying walls")
					numberofpiecesonboard = 0
					if $EnemyPieceselectpopup2/FfCelticWall.disabled != true:
						$EnemyPieceselectpopup2/FfCelticWall.disabled = true
					if $FriendlyPieceselectpopup/FfNormanWall.disabled != true:
						$FriendlyPieceselectpopup/FfNormanwall.disabled = true
					
					for tilebutton in get_tree().get_nodes_in_group("TileButtons"):
						if tilebutton.has_meta("piece_type") and tilebutton.get_meta("piece_type") == "wall":
							for y2 in range(FriendlyGameBoardArray.size()):
								for x2 in range(FriendlyGameBoardArray[y].size()):
					
									if FriendlyGameBoardArray[y2][x2] == 4:
			
										var tile_name = str(y + 1) + "_" + str(x + 1)
										var tile_node = get_node_or_null("FfMapBigger/" + tile_name)
										print("wall found at ", tile_name, ", position is ", tile_node.global_position)
										FriendlyGameBoardArray[y2][x2] = 0
										EnemyGameBoardArray[y2][x2] = 0
										UpdateBoardTextures()
										numberofpiecesonboard = 0
										if suddendeathtoggle == false and gamewon == false:
											suddendeathtoggle = true
											print("starting sudden death")
											$"Sudden Death Label".visible = true
											$SuddenDeathTitleTimer.start()
										else:
											print("sudden death already triggered this round, blocking it.")
										
					var draw_check: int = 0
					for y3 in range(FriendlyGameBoardArray.size()):
						for x3 in range(FriendlyGameBoardArray[y].size()):
					
							if FriendlyGameBoardArray[y3][x3] != 0:
								draw_check += 1
								if draw_check == 25 and gamewon == false:
									print("game is a draw")
									$"Draw Label".visible = true
									draw_check = 0
							else:
								draw_check = 0
					
					
			else:
				pass

func _on_sudden_death_title_timer_timeout() -> void:
	$"Sudden Death Label".visible = false

#################################ENEMY BOTS#########################################################
@export var BotDifficulty : int = 0 ## 0 for dumb bot, 1 for semi smart, 1 for expert

#######################################DUMB BOT#####################################################

func _on_dumb_bot_delay_timeout() -> void: # makes dumb bot wait 3 seconds before thinking
	dumb_bot_move_picker()

func dumb_bot_move_picker() -> void:
	var walls_available : bool = true
	if gamewon == false and BotDifficulty == 0:
		var random_y = randi() % EnemyGameBoardArray.size()
	
		var random_x = randi() % EnemyGameBoardArray[random_y].size()
	
		print(EnemyGameBoardArray)
	
		var random_value = EnemyGameBoardArray[random_x][random_y]
		print("[Dumb Bot] Random value: ", random_value, " at ", (random_x + 1), ", ", (random_y + 1))
		if random_value == 0:
			
			var available_pieces = []
			for piece in EnemyInventory.keys():
				if EnemyInventory[piece] <= 0:
					walls_available = false
				if EnemyInventory[piece] > 0:
					var weight = 1
					if piece.find("FfCelticFort") != -1:
						weight = 6
					if piece.find("FfCelticWall") != -1:
						walls_available = true
						weight = 1
					if piece.find("FfCelticTrader") != -1:
						if walls_available == true:
							weight = 1
						else:
							weight = 2
					for i in range(weight):
						available_pieces.append(piece)
						print(available_pieces)
						
			if available_pieces.size() == 0:
				print("[Dumb Bot] My inventory is empty!")
			
			var size = available_pieces.size()
			var random_piece = available_pieces[randi() % available_pieces.size()]
		
			print("[Dumb Bot] Placing ", random_piece, " on ", (random_x + 1), ", ", (random_y + 1))
			HoldingItem = true
			PieceSelectionCheck[random_piece] = true
			var tile_name = "%d_%d" % [random_x + 1, random_y + 1]
			var tile_path = "FfMapBigger/"+ tile_name
			if has_node(tile_path):
				var tile_node = get_node(tile_path)
				_on_tile_button_pressed(tile_node)
			else:
				print("Tile node not found: ", tile_path)
			
			if random_piece == "FfCelticWall":
				print("[Dumb Bot] I placed a wall, taking another turn...")
				$"Dumb Bot Delay".start()
		
		else:
			print("[Dumb Bot] Tile: ", (random_x + 1), ", ", (random_y + 1), " already occupied, picking another spot...")
			dumb_bot_move_picker()
	
	
	


####################SOUNDDESIGN#########################################################################

func _on_mini_menu_button_mouse_entered() -> void:
	$MiniMenuHover.play()

func _on_tile_button_hovered(button): #this determines the sound and pitch of when you hover over the menu pieces
	#var PieceMetaData = button.get_meta("piece_type")
	if button.get_meta("piece_type") == "empty" and button.disabled == false:
		hoverpitch = randf_range(1, 2) #pitch scale range, picks a number between 1.00 and 2.00
		$Hover_Tile_Button_Sound.pitch_scale = hoverpitch
		$Hover_Tile_Button_Sound.play()
		#print("tile button hovered over")
	else:
		#print("no meta data found")
		pass

func _on_menu_button_hovered(button): #this determines the sound and pitch of when you hover over the menu pieces
	if button.disabled == false:
		hoverpitch = randf_range(1, 2) #pitch scale range, picks a number between 1.00 and 2.00
		$Hover_Pop.pitch_scale = hoverpitch
		$Hover_Pop.play()
		#print("tile button hovered over")

func _on_mini_menu_button_hovered(_button):
	$MiniMenuHover.play()
