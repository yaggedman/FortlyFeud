extends Node2D

#each tile is 216x216 pixels
## TO DO:
## - Win conditions!!
## "Advance Turn" button. instead of automatic turn order


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
	"FfNormanTrader_Hover": preload("res://Assets/Textures/StyleBoxes/FfNormanTrader_Hover_SB.tres")
}

var tacview_stylebox_dict = {
	"FfCelticFort": preload("res://Assets/Textures/StyleBoxes/TACVIEW_NormanFort.tres"),
	"FfCelticTrader": preload("res://Assets/Textures/StyleBoxes/TACVIEW_NormanTrader.tres"),
	"FfNormanFort": preload("res://Assets/Textures/StyleBoxes/TACVIEW_CelticFort.tres"),
	"FfNormanTrader": preload("res://Assets/Textures/StyleBoxes/TACVIEW_CelticTrader.tres"),
}

var HoldingItem: bool = false
var SpriteFollowingMouse: Sprite2D = null
var turnordercount: int = 1
var FriendlyMenuShut = false
var EnemyMenuShut = false
var minimenushut = true
var tacticalview = false

func _ready():
	
	tacticalview = false
	
	$HammerAnimation.visible = false
	$HammerAnimation.play("default")
	
	
	## gets buttons in the button group, and connects the pressed signal with argument button
	for tilebutton in get_tree().get_nodes_in_group("TileButtons"):
		tilebutton.pressed.connect(Callable(self, "_on_tile_button_pressed").bind(tilebutton))
		
## gets buttons in the menupieces group and connects the pressed signal with argument menupiece
	for menupiece in get_tree().get_nodes_in_group("MenuPieces"):
		menupiece.pressed.connect(Callable(self, "_on_menupiece_button_pressed").bind(menupiece))
	
	for PieceSelectionKey in PieceSelectionCheck.keys(): # sets all pieces to be deselected on game start-up
		PieceSelectionCheck[PieceSelectionKey] = false
		
	print("it is the Norman's turn")
	$EnemyPieceselectpopup2/FfCelticFort.disabled = true
	$EnemyPieceselectpopup2/FfCelticTrader.disabled = true
	$FriendlyPieceselectpopup/FfNormanFort.disabled = false
	$FriendlyPieceselectpopup/FfNormanTrader.disabled = false
		
func turnorder(): # decides turn order, and disables buttons when it's not your turn
	turnordercount += 1
	if turnordercount %2 == 0:
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
	"FfCelticWall" = 2
}
	

func _on_menupiece_button_pressed(menupiece): # true for all menu pieces, when menu piece selected
	UpdateBoardTextures()
	if HoldingItem == false: # only runs code if hand is empty
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
								$HammerAnimation.position = tile_node.global_position + Vector2(100,100)
								$HammerAnimation.visible = true
								
				if menupiece.name == "FfCelticTrader":
					
					for y in range(EnemyGameBoardArray.size()):
						for x in range(EnemyGameBoardArray[y].size()):
							if EnemyGameBoardArray[y][x] == 2:
								var tile_name = str(y + 1) + "_" + str(x + 1)
								var tile_node = get_node_or_null("FfMapBigger/" + tile_name)
								print("trader found at ", tile_name, ", position is ", tile_node.global_position)
								$HammerAnimation.position = tile_node.global_position + Vector2(100,100)
								$HammerAnimation.visible = true
								
				PieceSelectionCheck[menupiece.name] = true # select that piece
				HoldingItem = true # set holding status to true, prevents multiple valid selections
			else:
				print(menupiece, " not found in dictionary") # debug, piece does not exist in the dictionary
	print(PieceSelectionCheck) # prints all pieces and whether they are selected or not (true/false)
	
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
	
func _process(float) -> void:
	#PlaceNewTrader() #debug
	#matrix_search() #debug
	var mousepos : Vector2 = get_viewport().get_mouse_position()
	if HoldingItem == true and SpriteFollowingMouse == null:
		SpriteFollowingMouse = Sprite2D.new()
		for Piece in PieceSelectionCheck:
			if PieceSelectionCheck[Piece] == true:
				SpriteFollowingMouse.name = str(Piece) + "_following_mouse"
				#print(SpriteFollowingMouse.name) - debug, prints the name of the new child
				SpriteFollowingMouse.texture = PieceTextureDict[Piece] #sets the texture
				if Piece != "FfCelticWall" and Piece != "FfNormanWall":
					SpriteFollowingMouse.z_index = 5
					SpriteFollowingMouse.scale = Vector2(8,8)
				add_child(SpriteFollowingMouse)
				if Piece == "FfCelticWall" or Piece == "FfNormanWall":
					SpriteFollowingMouse.z_index = 5
	if SpriteFollowingMouse:
		SpriteFollowingMouse.position = mousepos
		#print(SpriteFollowingMouse.name)
	
	

func _on_tile_button_pressed(tilebutton):
	
	UpdateBoardTextures()
	print("tile ", tilebutton.name, " selected") # debug - prints selected tile to console 
	
	#if HoldingItem == false: #when no piece is selected from menu and tile is selected, run the moveable trader script
	#TraderMove(tilebutton)
		
	
	if HoldingItem == true: # only runs code if the player has a piece selected
		
		for Piece in PieceSelectionCheck: # runs through all pieces, and selects the piece that has been chosen from the piece menu
			if PieceSelectionCheck[Piece] == true:
				print (Piece, " placed on tile ", tilebutton.name) # debug - prints name of piece and tile it has been placed on to console
				PlaceNewTrader()
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
						print("Updated Friendly Board: ", FriendlyGameBoardArray) # prints to console
						
						
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
						print("Updated Enemy Board: ", EnemyGameBoardArray) # prints to console
						#tilebutton.set_meta("piece_type", "celt")
						
						UpdateBoardTextures()
						#InvisibleCheck()
						for key in PieceSelectionCheck.keys():
							PieceSelectionCheck[key] = false #sets all pieces to not selected
						
					else:
						print("tile: ", tilebutton, " already occupied!")
					
				else:
					print("Invalid tile indices:", row, col) # debug
					
					
					
		
		
func UpdateBoardTextures():
	
	

			
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
			var is_friendly = false
		
			if enemy_piece_number == 0:
				var new_stylebox = preload("res://Assets/Textures/StyleBoxes/FfEmpty.tres")
				var new_stylebox_hover = preload("res://Assets/Textures/StyleBoxes/FfEmptyHover.tres")
				tilebutton.add_theme_stylebox_override("normal", new_stylebox)
				tilebutton.add_theme_stylebox_override("hover", new_stylebox_hover)
				
			
			if piece_number == 4: #specifcally updates wall textures
				var wallstylebox = preload("res://Assets/Textures/StyleBoxes/FfNormanWall_SB.tres")
				var wallstyleboxhover = preload("res://Assets/Textures/StyleBoxes/FfNormanWall_SB.tres")
				tilebutton.add_theme_stylebox_override("normal", wallstylebox)
				tilebutton.add_theme_stylebox_override("hover", wallstylebox)
				
			if piece_number != 0 and piece_number !=4:
				#var tilebutton = get_node_or_null("FfMapBigger/%s" % tile_name)
				if tilebutton.get_meta("piece_type") == "norman": #if the tile button  is norman, use the friendly array
					for piece in FriendlyPieceNumberRef.keys(): # this chunk finds the piece name from the FriendlyPieceNumberRef
						if FriendlyPieceNumberRef[piece] == piece_number:
							piece_name = piece
							is_friendly = true
							print("piece is friendly!")
							break
					
				elif tilebutton.get_meta("piece_type") == "celt":
					for enemypiece in EnemyPieceNumberRef.keys():
						if EnemyPieceNumberRef[enemypiece] == enemy_piece_number:
							piece_name = enemypiece
							is_friendly = false
							print("piece is enemy!")
							break
				
				if piece_name and stylebox_dict.has(piece_name) and tacticalview == false:
					#var tile_button = get_node_or_null("FfMapBigger/%s" % tile_name) # Find the button by name
					if tilebutton:
						tilebutton.add_theme_stylebox_override("normal", stylebox_dict[piece_name])
						tilebutton.add_theme_stylebox_override("hover", stylebox_dict[piece_name]) # changes stylebox of button
						print("Updated tile", tile_name, 	"with stylebox for ", piece_name)
				
				elif piece_name and tacview_stylebox_dict.has(piece_name) and tacticalview == true:
					if tilebutton:
						tilebutton.add_theme_stylebox_override("normal", tacview_stylebox_dict[piece_name])
						tilebutton.add_theme_stylebox_override("hover", tacview_stylebox_dict[piece_name]) # changes stylebox of button
						print("Updated tile", tile_name, 	"with stylebox for ", piece_name)
						
			elif piece_number != 4 or enemy_piece_number !=4: #this sets stylebox of empty tiles, useful for when traders are picked up
				var new_stylebox = preload("res://Assets/Textures/StyleBoxes/FfEmpty.tres")
				var new_stylebox_hover = preload("res://Assets/Textures/StyleBoxes/FfEmptyHover.tres")
				tilebutton.add_theme_stylebox_override("normal", new_stylebox)
				tilebutton.add_theme_stylebox_override("hover", new_stylebox_hover)
				
			
				
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
				$SmokeAnimation.position = tile_node.global_position + Vector2(100,100)
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
				$SmokeAnimation.position = tile_node.global_position + Vector2(100,100)
				$SmokeAnimation.visible = true
				$SmokeAnimation.play("default")
				
				
				
				#for button in get_tree().get_nodes_in_group("TileButtons"):
					#if button is Button:
						#var current_stylebox = button.get_theme_stylebox("normal") or button.get_stylebox("normal")
				#
						#if current_stylebox == preload("res://Assets/Textures/StyleBoxes/FfNormanTrader_SB.tres"):
							#print("Trader already exists!")
		#else:
			#print("not a norman trader")
		
#func TraderMove(tilebutton):
	#
	#print("no piece selected! checking if ", tilebutton.name, " has a trader...")
	#
	#var indices = TilesDict[tilebutton.name] # gets [row, col] from dictionary
	#var row = int(indices[0]) - 1
	#var col = int(indices[1]) - 1
	#
	#if turnordercount %2 == 0: # if it's the celt's turn
		#var enemy_piece_number = EnemyGameBoardArray[row][col]
		#
		#if enemy_piece_number == 2:
			#tilebutton.visible = false
			#HoldingItem = true
			#print("tile is a celtic trader, picking up piece...")
			#PieceSelectionCheck["FfCelticTrader"] = true
		#else:
			#print ("tile is not a celtic trader")
	#else: #if it is the norman's turn
		#var piece_number = FriendlyGameBoardArray[row][col]
		#
		#if piece_number == 2:
			#tilebutton.visible = false
			#HoldingItem = true
			#print("tile is a norman trader, picking up piece...")
			#PieceSelectionCheck["FfNormanTrader"] = true
			##FriendlyGameBoardArray[row][col] = 0 #does this too early...
			#UpdateBoardTextures()
			#
		#else:
			#print("tile is not a norman trader")
			#
#func InvisibleCheck():
	#var buttons = get_tree().get_nodes_in_group("TileButtons")
	#var any_hidden = false
	#var hidden_button = null
	#
	#for button in buttons:
		#if not button.visible:
			#any_hidden = true
			#hidden_button = button
			#break
	#if any_hidden:
		#for button in buttons:
			#button.visible = true
	#
	#if hidden_button != null:
		#var indices = TilesDict[hidden_button.name] # gets [row, col] from dictionary
		#var row = int(indices[0]) - 1
		#var col = int(indices[1]) - 1
		#FriendlyGameBoardArray[row][col] = 0
		#EnemyGameBoardArray[row][col] = 0
		
		

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
		$Buttonblankfix.visible = true
		minimenushut = false
		
	elif minimenushut == false:
		$Buttonblankfix.visible = false
		minimenushut = true

func _on_mini_menu_resume_pressed() -> void: #toggles mini menu from the resume button in the mini menu
	if minimenushut == false:
		$Buttonblankfix.visible = false
		minimenushut = true
	else:
		print("error: mini menu shut but resume button pressed!")
		

func _on_mini_menu_quit_pressed() -> void:
	if minimenushut == false:
		get_tree().change_scene_to_file("res://Assets/Scenes/main_menu.tscn")
	else:
		print("error: mini menu shut but quit button pressed!")
	
	
func _on_mini_menu_restart_pressed() -> void:
	if minimenushut == false:
		get_tree().reload_current_scene()
	else:
		print("error: mini menu shut but restart button pressed!")


func _on_tactical_view_button_pressed() -> void:
	if tacticalview == false:
		print("tactical view turned on")
		$TacViewAnimation.play("OffToOn")
		tacticalview = true
		$TacViewGreyOverlay.visible = true
		UpdateBoardTextures()
		
		
	elif tacticalview == true:
		print("tacitcal view turned off")
		$TacViewAnimation.play("OnToOff")
		tacticalview = false
		$TacViewGreyOverlay.visible = false
		UpdateBoardTextures()
		
		
		
