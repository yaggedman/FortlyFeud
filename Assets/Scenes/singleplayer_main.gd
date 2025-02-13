extends Node2D

#declares tile map dictionary
@onready var tile_map = {}
var FriendlyPieceMenuRevealed : bool = true
var EnemyPieceMenuRevealed : bool = true

var dragging : bool = false

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
	
var sprite_following_mouse : Sprite2D = null # this stores the sprite that is following the mouse

func _process(delta):
	var mousepos : Vector2 = get_viewport().get_mouse_position()
	
	for key in piece_selection.keys():
		if piece_selection[key] and PieceInventory.has(key) and PieceInventory[key] > 0:
			if sprite_following_mouse == null: #only creates one sprite if not already created
				sprite_following_mouse = Sprite2D.new()
				add_child(sprite_following_mouse) # adds a new sprite2d to the scene
				
				sprite_following_mouse.texture = piece_textures[key] #sets the texture
				
				var ProceedMouseFollowing : bool = true
				
				
			sprite_following_mouse.position = mousepos
			sprite_following_mouse.scale = Vector2(6.5, 6.5)
			sprite_following_mouse.z_index = 100 #ensures child is always on top of the scene


func _input(event: InputEvent) -> void: #on right click, discard piece
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_RIGHT and sprite_following_mouse != null:
			for key in piece_selection.keys():
				piece_selection[key] = false #sets all pieces to not selected
			sprite_following_mouse.queue_free() #kills the child
			sprite_following_mouse = null #resets so there is no sprite attached to mouse

func _on_tile_button_pressed(button): #if item selected and board tile selected, place piece on board
	print(button)
	if sprite_following_mouse != null: #if holding game piece
		for key in piece_selection.keys():
			if piece_selection[key]:
				piece_selection[key] = false #deselects piece
				if PieceInventory.has(key): 
					PieceInventory[key] -= 1 #removes 1 from inventory
					print(key, "remaining:", PieceInventory[key])
					if PieceInventory[key] == 0:
						PieceInventory.erase(key) # when out of game pieces, remove from dictionary
		sprite_following_mouse.centered = false
		sprite_following_mouse.position = Vector2(button.position) + Vector2(968,536)
		sprite_following_mouse = null
		button.visible = false # hides the yellow hover effect on tile
		#######################################################################################
		

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
