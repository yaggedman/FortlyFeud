extends Node2D

#declares tile map dictionary
@onready var tile_map = {}
var FriendlyPieceMenuRevealed : bool = true
var EnemyPieceMenuRevealed : bool = true

var dragging : bool = false

#creates a dictionary of pieces and whether they are selected or not (default false)
var piece_selection = {
	"FfcelticFort": false,
	"FfCelticTrader": false,
	"FfEnemyWall": false,
	"FfNormanFort": false,
	"FfNormanTrader": false,
	"FfFriendlyWall": false
	}

#Declaring inventory of Celts
@onready var CeltInventory = {
	"Fort" = 1000,
	"Trader" = 1,
	"Wall" = 1,
	
}

#Declaring inventory of Normans
@onready var NormanInventory = {
	"Fort" = 1000,
	"Trader" = 1,
	"Wall" = 2
}
var CeltFortSelected : bool = false
var CeltTraderSelected : bool = false
var CeltWallSelected : bool = false
var NormanFortSelected : bool = false
var NormanTraderSelected : bool = false
var NormanWallSelected : bool = false

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
	
	#declaring whether the side menus are revealed or not (revealed by default)
	FriendlyPieceMenuRevealed = true
	EnemyPieceMenuRevealed = true
	####################################################################################
	
	#generic input handler, loops through all the nodes in the MenuPieces group and connects their input_event signal
	for piece in get_tree().get_nodes_in_group("MenuPieces"):
		piece.input_event.connect(Callable(self, "_on_piece_input_event").bind(piece))
		
#Deselects all pieces in group MenuPieces, sets the selected piece to true on left click.
func _on_piece_input_event(piece, viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and not dragging:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			for key in piece_selection.keys():
				piece_selection[key] = false
			piece_selection[piece.name] = true

func _process(delta):
	var mousepos = get_viewport().get_mouse_position()
	
	# when piece is selected from side menu, set dragging state to true, and attach piece to mouse position
	if CeltFortSelected == true:
		dragging = true
		$DragCelticFort.position = mousepos + Vector2(-100,-100)
	
	if CeltTraderSelected == true:
		dragging = true
		$DragCelticTrader.position = mousepos + Vector2(-100,-100)
		
	if CeltWallSelected == true:
		dragging = true
		$DragWall.position = mousepos + Vector2(-100,-100)
		
	if NormanFortSelected == true:
		dragging = true
		$DragNormanFort.position = mousepos + Vector2(-100,-100)
		
	if NormanTraderSelected == true:
		dragging = true
		$DragNormanTrader.position = mousepos + Vector2(-100,-100)
		
	if NormanWallSelected == true:
		dragging = true
		$DragWall.position = mousepos + Vector2(-100,-100)
		
		
#if player is holding an item, press right click to discard (also stops multiple simultaneous selections)
func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_RIGHT and event.pressed and dragging:
			dragging = false
			print("testing")
			
			CeltFortSelected = false
			CeltTraderSelected = false
			CeltWallSelected = false
			NormanFortSelected = false
			NormanTraderSelected = false
			NormanWallSelected = false
			$DragCelticFort.position = Vector2(2500,1500)
			$DragCelticTrader.position = Vector2(2500,1500)
			$DragWall.position = Vector2(2500,1500)
			$DragNormanFort.position = Vector2(2500,1500)
			$DragNormanTrader.position = Vector2(2500,1500)
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
##################################################################################

	
func _on_tile_button_pressed(button):
	print(button.position)
	if dragging == true:
		dragging = false
		if NormanFortSelected:
			NormanFortSelected = false
			$DragNormanFort.position = button.position + Vector2(968,536)
		if NormanTraderSelected:
			NormanTraderSelected = false
			$DragNormanTrader.position = button.position + Vector2(968,536)
		if NormanWallSelected:
			NormanWallSelected = false
			$DragWall.position = button.position + Vector2(968,536)
		if CeltFortSelected:
			CeltFortSelected = false
			$DragCelticFort.position = button.position + Vector2(968,536)
		if CeltTraderSelected:
			CeltTraderSelected = false
			$DragCelticTrader.position = button.position + Vector2(968,536)
		if CeltWallSelected:
			CeltWallSelected = false
			$DragWall.position = button.position + Vector2(968,536)

func testfunction():
	for key in piece_selection.keys():
		if piece_selection[key]:
			print("Selected piece:", key)
