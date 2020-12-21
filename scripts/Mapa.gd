extends Node2D

var TileMap = preload("../scenes/TileMap.tscn")
var tilemap_size = 8
var screen_size

func _ready():
	screen_size = get_viewport_rect().size
	generate_all()

func generate_all():
	generate_vertical()
	generate_vertical(screen_size.x)
	generate_horizontal()
	generate_horizontal(screen_size.y)

#La razón por la que utilizo 2 funciones iguales en lugar de una para las 2
#es porque si utilizara solo una función, debería estar revisando 
#si es_vertical == true  en cada iteración del for
func generate_vertical(x = 0 , min_y = 0 , max_y = screen_size.y):
	var max_tiles = 1+(max_y-min_y)*tilemap_size
	var tm
	for i in max_tiles:
		var pos = (min_y - tilemap_size) + (tilemap_size * 2 * i)
		tm = TileMap.instance()
		tm.position.y = pos
		tm.position.x = x
		add_child(tm)

func generate_horizontal(y = 0 , min_x = 0 , max_x = screen_size.x):
	var max_tiles = 1+(max_x-min_x)*tilemap_size
	var tm
	for i in max_tiles:
		var pos = (min_x - tilemap_size) + (tilemap_size * 2 * i)
		tm = TileMap.instance()
		tm.position.x = pos
		tm.position.y = y
		add_child(tm)

# -tilemap_size + (tilemap_size * 2 * i)
