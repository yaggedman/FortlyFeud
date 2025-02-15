extends Node2D

#declares tile map dictionary
@onready var tile_map = {}
var OutofMenuPieces = {}
var FriendlyPieceMenuRevealed : bool = true
var EnemyPieceMenuRevealed : bool = true
var TurnOrder : int = 2
var CelticWallDisabled : bool = false
var CelticTraderDisabled : bool = false
var NormanWallDisabled : bool = false
var NormanTraderDisabled : bool = false
var TraderMoved : bool = false

var dragging : bool = false
var FollowingMouseButton = Button.new()

#creates a dictionary of pieces and whether they are selected or not (default false)
var piece_selection = {
	"FfCelticFort": false,
	"FfCelticTrader": false,
	"FfCelticWall": false,
	"FfNormanFort": false,
	"FfNormanTrader": false,
	"FfNormanWall": false
	}

#Declaring inventory of Players
@onready var PieceInventory = {
	"FfCelticFort" = 1000,
	"FfCelticTrader" = 1,
	"FfCelticWall" = 1,
	"FfNormanFort" = 1000,
	"FfNormanTrader" = 1,
	"FfNormanWall" = 2
}
var piece_textures = {
	"FfCelticFort": preload("res://Assets/Sprites/FF_CelticFort_Muted.png"),
	"FfCelticTrader": preload("res://Assets/Sprites/FF_CelticTrader_Muted.png"),
	"FfCelticWall": preload("res://Assets/Sprites/FF_Wall.png"),
	"FfNormanFort": preload("res://Assets/Sprites/FF_NormanFort_Muted.png"),
	"FfNormanTrader": preload("res://Assets/Sprites/FF_NormanTrader_Muted.png"),
	"FfNormanWall": preload("res://Assets/Sprites/FF_Wall.png")
}

var PiecesOnBoard = {}

func _on_menupiece_button_hover(menupiece):
	menupiece.scale *= 1.2

func _on_menupiece_button_pressed(menupiece):
	for key in piece_selection.keys():
		piece_selection[key] = false #sets all pieces to not selected
		piece_selection[menupiece.name] = true #selects pressed piece
	#print(piece_selection) #debug - prints the dictionary

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
	var OutofMenuPieces = {
	"FfCelticTrader": $EnemyPieceselectpopup2/FfCelticTrader,
	"FfCelticWall": $EnemyPieceselectpopup2/FfCelticWall,
	"FfNormanTrader": $FriendlyPieceselectpopup/FfNormanTrader,
	"FfNormanWall": $FriendlyPieceselectpopup/FfNormanWall,
}
	
	for _i in self.get_children():
		print (_i) # debug prints all children


# gets buttons in the button group, and connects the pressed signal with argument button
	for button in get_tree().get_nodes_in_group("TileButtons"):
		button.pressed.connect(Callable(self, "_on_tile_button_pressed").bind(button))
		
# gets buttons in the menupeices group and connects the pressed signal with argument menupiece
	for menupiece in get_tree().get_nodes_in_group("MenuPieces"):
		menupiece.pressed.connect(Callable(self, "_on_menupiece_button_pressed").bind(menupiece))
	
	#declaring whether the side menus are revealed or not (revealed by default)
	FriendlyPieceMenuRevealed = true
	EnemyPieceMenuRevealed = true
	####################################################################################
	
var sprite_following_mouse : Sprite2D = null # this stores the sprite that is following the mouse on piece select
var sprite_following_mouse_button : Button = null
var SpriteOnBoard : Sprite2D = null

func _process(delta):
	
	
	if TurnOrder % 2 == 0: #determines play order and disables pieces accordingly (walls can be placed any time)
		$EnemyPieceselectpopup2/FfCelticFort.disabled = true
		$EnemyPieceselectpopup2/FfCelticTrader.disabled = true
		$FriendlyPieceselectpopup/FfNormanFort.disabled = false
		$FriendlyPieceselectpopup/FfNormanTrader.disabled = false
		if NormanWallDisabled == true: #this code sucks but makes sure pieces stay disabled if there are 0 in invent
			$FriendlyPieceselectpopup/FfNormanWall.disabled = true
		if NormanTraderDisabled == true:
			$FriendlyPieceselectpopup/FfNormanTrader.disabled = true
			
	else:
		$EnemyPieceselectpopup2/FfCelticFort.disabled = false
		$EnemyPieceselectpopup2/FfCelticTrader.disabled = false
		$FriendlyPieceselectpopup/FfNormanFort.disabled = true
		$FriendlyPieceselectpopup/FfNormanTrader.disabled = true
		if CelticWallDisabled == true:
			$EnemyPieceselectpopup2/FfCelticWall.disabled = true
		if CelticTraderDisabled == true:
			$EnemyPieceselectpopup2/FfCelticTrader.disabled = true
		
	
	var mousepos : Vector2 = get_viewport().get_mouse_position()
	
	for key in piece_selection.keys():
		if piece_selection[key] and PieceInventory.has(key) and PieceInventory[key] > 0:
			if sprite_following_mouse == null: #only creates one sprite if not already created
				sprite_following_mouse = Sprite2D.new()
				sprite_following_mouse_button = Button.new()
				SpriteOnBoard = Sprite2D.new()
				add_child(sprite_following_mouse) # adds a new sprite2d to the scene
				add_child(sprite_following_mouse_button)
				add_child(SpriteOnBoard)
				sprite_following_mouse.name = key + "_child" + str(PieceInventory[key]) + "_temp"
				SpriteOnBoard.name = key + "_child" + str(PieceInventory[key]) + "real"
				if SpriteOnBoard.name == "FfNormanTrader_child1real2":
					SpriteOnBoard.name == "FfNormanTrader_child1real"
				sprite_following_mouse_button.name = key + "_child_button" + str(PieceInventory[key]) + "_temp"
				sprite_following_mouse_button.pressed.connect(self._on_following_mouse_button_pressed.bind(sprite_following_mouse_button))
				sprite_following_mouse_button.position = Vector2(2500,2500)
				SpriteOnBoard.position = Vector2(2500,2500)
				sprite_following_mouse.texture = piece_textures[key] #sets the texture
				SpriteOnBoard.texture = piece_textures[key]
				if key == "FfNormanTrader":
					sprite_following_mouse_button.editor_description = "NormanTest"
					SpriteOnBoard.name = "FfNormanTrader_child1real"
				if key == "FfCelticTrader":
					sprite_following_mouse_button.editor_description = "CelticTest"
					SpriteOnBoard.name = "FfCelticTrader_child1real"
				if key == "FfCelticWall" or key == "FfNormanWall":
					SpriteOnBoard.editor_description = "WallHere"
					
				
				var ProceedMouseFollowing : bool = true
				
			sprite_following_mouse.position = mousepos
			sprite_following_mouse.scale = Vector2(6.5, 6.5)
			SpriteOnBoard.scale = Vector2(6.5,6.5)
			sprite_following_mouse_button.set_size(Vector2(210,210))
			SpriteOnBoard.z_index = 99
			sprite_following_mouse.z_index = 100 #ensures child is always on top of the scene
			sprite_following_mouse_button.z_index = 101
	

func _input(event: InputEvent) -> void: #on right click, discard piece
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_RIGHT and sprite_following_mouse != null:
			for key in piece_selection.keys():
				piece_selection[key] = false #sets all pieces to not selected
			sprite_following_mouse.queue_free() #kills the child
			sprite_following_mouse_button.queue_free()
			SpriteOnBoard.queue_free()
			#sprite_following_mouse = null #resets so there is no sprite attached to mouse
			#sprite_following_mouse_button = null

func _on_tile_button_pressed(button): #if item selected and board tile selected, place piece on board
	print(button)
	if sprite_following_mouse != null: #if holding game piece
		for key in piece_selection.keys():
			if piece_selection[key]:
				piece_selection[key] = false #deselects piece
				if PieceInventory.has(key): 
					PieceInventory[key] -= 1 #removes 1 from inventory
					if key == "FfCelticWall" or key == "FfNormanWall":
						pass
					else:
						TurnOrder +=1
					var PieceOnBoardKey = str(button) + "_" + str(key)
					PiecesOnBoard[PieceOnBoardKey] = {
						"tile": button,
						"piece": key
					}
					print("Placed piece on board: ", key)
					print(PiecesOnBoard)
					print(key, "remaining:", PieceInventory[key])
					for _i in self.get_children (): #debug - prints a list of all children
						print(_i)
					if PieceInventory[key] == 0: #when out of pieces, disables ability to select piece from menu
						print((key))
						var new_stylebox = StyleBoxFlat.new()
						new_stylebox.bg_color = Color(0.27,0.27,0.27,1)
						if key == "FfCelticWall":
							$EnemyPieceselectpopup2/FfCelticWall.disabled = true
							CelticWallDisabled = true
							print("CelticWallDisabled")
						if key == "FfCelticTrader":
							$EnemyPieceselectpopup2/FfCelticTrader.disabled = true
							print("CelticTraderDisabled")
							CelticTraderDisabled = true
						if key == "FfNormanWall":
							$FriendlyPieceselectpopup/FfNormanWall.disabled = true
							NormanWallDisabled = true
							print("NormanWallDisabled")
						if key == "FfNormanTrader":
							$FriendlyPieceselectpopup/FfNormanTrader.disabled = true
							NormanTraderDisabled = true
							print("NormanTraderDisabled")
						#PieceInventory.erase(key) # when out of game pieces, remove from dictionary
		sprite_following_mouse.centered = false
		SpriteOnBoard.centered = false
		#sprite_following_mouse.position = Vector2(button.position) + Vector2(968,536)
		SpriteOnBoard.position = Vector2(button.position) + Vector2(968,536)
		sprite_following_mouse_button.position = Vector2(button.position) + Vector2(968,536)
		sprite_following_mouse.queue_free()
		sprite_following_mouse = null
		SpriteOnBoard.visible = true
		TraderMoved = false
		#sprite_following_mouse_button = null
		#button.visible = false # hides the yellow hover effect on tile and prevents multiple placements on the same tile
		#######################################################################################
		
func _on_following_mouse_button_pressed(sprite_following_mouse_button): #on piece button pressed, check if trader
	if sprite_following_mouse_button != null:
		if sprite_following_mouse_button.editor_description == "NormanTest": #checks for trader tag
			if SpriteOnBoard.name == "FfNormanTrader_child1real2": #dont think this does anything
				SpriteOnBoard.name == "FfNormanTrader_child1real" #dont think this does anything
			SpriteOnBoard.visible = false #makes old sprite invisible
			sprite_following_mouse_button.queue_free() # kills old button
			PieceInventory["FfNormanTrader"] += 1
			piece_selection["FfNormanTrader"] = true
			print(piece_selection)
			SpriteOnBoard.queue_free() # kills old sprite
			TraderMoved = true
		if sprite_following_mouse_button.editor_description == "CelticTest":
			SpriteOnBoard.visible = false #makes old sprite invisible
			sprite_following_mouse_button.queue_free() # kills old button
			PieceInventory["FfCelticTrader"] += 1
			piece_selection["FfCelticTrader"] = true
			print(piece_selection)
			SpriteOnBoard.queue_free() # kills old sprite
			TraderMoved = true
			
		else:
			print("button is not a trader")
	else:
		print("sprite_following_mouse is null")

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
#########################################################################################
