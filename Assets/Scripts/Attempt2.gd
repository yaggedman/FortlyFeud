extends Node2D

#each tile is 216x216 pixels


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

var HoldingItem: bool = false

func _ready():
	## gets buttons in the button group, and connects the pressed signal with argument button
	for tilebutton in get_tree().get_nodes_in_group("TileButtons"):
		tilebutton.pressed.connect(Callable(self, "_on_tile_button_pressed").bind(tilebutton))
		
## gets buttons in the menupieces group and connects the pressed signal with argument menupiece
	for menupiece in get_tree().get_nodes_in_group("MenuPieces"):
		menupiece.pressed.connect(Callable(self, "_on_menupiece_button_pressed").bind(menupiece))
	
	for PieceSelectionKey in PieceSelectionCheck.keys(): # sets all pieces to be deselected on game start-up
		PieceSelectionCheck[PieceSelectionKey] = false
		
func _on_menupiece_button_pressed(menupiece): # true for all menu pieces, when menu piece selected
	if HoldingItem == false: # only runs code if hand is empty
		print(menupiece.name, " pressed! Waiting for tile selection or discard") # debug - prints selected piece to console
		for Piece in PieceSelectionCheck: # loops through all pieces
			if PieceSelectionCheck.has(menupiece.name): # if the piece is valid
				PieceSelectionCheck[menupiece.name] = true # select that piece
				HoldingItem = true # set holding status to true, prevents multiple valid selections
			else:
				print(menupiece, " not found in dictionary") # debug, piece does not exist in the dictionary
	print(PieceSelectionCheck) # prints all pieces and whether they are selected or not (true/false)

func _on_tile_button_pressed(tilebutton):
	print("tile ", tilebutton.name, " selected") # debug - prints selected tile to console
	if HoldingItem == true: # only runs code if the player has a tile selected
		for Piece in PieceSelectionCheck: # runs through all pieces, and selects the piece that has been chosen from the piece menu
			if PieceSelectionCheck[Piece] == true:
				print (Piece, " placed on tile ", tilebutton.name) # debug - prints name of piece and tile it has been placed on to console
				for tile in TilesDict:
					if TilesDict.has(tilebutton):
						pass # append to array
