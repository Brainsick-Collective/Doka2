extends Node

"""
Finds the path between two points using AStar, in grid coordinates
"""

var astar = AStar.new()

var _obstacles 
var _map_size
var _spaces
var _path_tiles

enum CELL_TYPES {PATH, SPACE, GRASS, BUSH, DIRT}

func initialize(grid):
	_path_tiles = []
	_map_size = grid.get_used_rect().size
	
	var path_cells = grid.get_node("Path").get_used_cells_by_id(PATH)
	for cell in path_cells:
		_path_tiles.append(cell)
	# Find all walkable cells and store them in an array
	var points_array = []
	for y in range(_map_size.y):
		for x in range(_map_size.x):
			var point = Vector2(x, y)
			if point in _path_tiles:
				points_array.append(point)
				var point_index = calculate_point_index(point)
				astar.add_point(point_index, Vector3(point.x, point.y, 0))
	# Loop through all walkable cells and their neighbors
	# to connect the points
	for point in points_array:
		var point_index = calculate_point_index(point)
		for local_y in range(3):
			for local_x in range(3):
				var point_relative = Vector2(point.x + local_x - 1, point.y + local_y - 1)
				var point_relative_index = calculate_point_index(point_relative)

				if point_relative == point or is_outside_map_bounds(point_relative):
					continue
				if not astar.has_point(point_relative_index):
					continue
				astar.connect_points(point_index, point_relative_index, false)

func is_outside_map_bounds(point):
	return point.x < 0 or point.y < 0 or point.x >= _map_size.x or point.y >= _map_size.y

func calculate_point_index(point):
	return int(point.x + _map_size.x * point.y)

func find_path(start, end):
	"""
	Returns an array of cells that connect the start and end positions
	in grid coordinates
	"""
	var start_index = calculate_point_index(start)
	var end_index = calculate_point_index(end)
	return astar.get_point_path(start_index, end_index)

