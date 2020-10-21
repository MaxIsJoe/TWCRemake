extends TileMap

#onready var lightfov = preload("res://Scenes/Levels/Tilesets/LightOclloder.tscn")

func _ready():
	pass
	#var cell_positions = self.get_used_cells()
	#for pos in cell_positions:
	#	var tile_id = self.get_cellv(pos)
	#	var tile_name = self.get_tileset().tile_get_name(tile_id)
	#	if(tile_name == "Roof1"):
	#		var n = lightfov.instance()
	#		add_child(n)
