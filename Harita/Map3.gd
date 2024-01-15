extends Node


var start
var end
var all_nodes = []
var id = 2
var node_temp

func _ready():
	node_temp = load("res://node.tscn")
	start = node_temp.instantiate()
	start.id = 0
	end = node_temp.instantiate()
	end.id = 1
	end.double_entry = true
	all_nodes.append(start)
	all_nodes.append(end)
	var length = randi_range(6,9)
	print(length)
	var prev_right = start
	var prev_left = start
	for distance in range(length):
		var right_node = node_temp.instantiate()
		all_nodes.append(right_node)
		right_node.distance = distance
		right_node.id = id
		id +=1
		right_node.side = 0
		var left_node = node_temp.instantiate()
		all_nodes.append(left_node)
		left_node.distance = distance
		left_node.id = id
		id += 1
		left_node.side = 1
		prev_right.left = right_node
		prev_left.right = left_node
		prev_right = right_node
		prev_left = left_node
	prev_left.right = end
	prev_right.left = end 
	var new_paths = randi_range(3,5)
	for path in range(new_paths):
		var path_start_id = randi_range(2, id)
		var path_end_id = randi_range(2, id)
		var path_start
		var path_end
		var path_nodes = []
		if path_start_id != path_end_id:
			for node in all_nodes:
				if node.double_entry == true:
					continue
				if node.id == path_start_id:
					path_start = node
				if node.id == path_end_id:
					path_end = node
		if path_end == null or path_start == null:
			continue
		var path_length
		print(path_start)
		print(path_end)
		print(path_start.side)
		print(path_end.side)
		if path_start.side != path_end.side:
			path_length = randi_range(2,4)
		elif path_start.distance > path_end.distance:
			path_length = path_start.distance - path_end.distance
		else:
			path_length = path_end.distance - path_start.distance
		print("lol")
		for node in range(path_length):
			var new_node = node_temp.instantiate()
			new_node.id = id
			id += 1
	for node in all_nodes:
		add_child(node)
	draw()


func create_node(side):
	var new_node = node_temp.instantiate()
	new_node.id = id
	id += 1
	new_node.side = side
	all_nodes.append(new_node)
	return new_node


func create_road(length, starting_node, ending_node):
	return


func draw():
	var center = get_viewport().get_visible_rect().get_center()
	var length = get_viewport().get_visible_rect().size.x
	print(length)
	start.position = center - Vector2(length/2 - length * 1/20, 0)
	draw_helper(start)


func draw_helper(current):
	if current.right != null:
		if current.left == null:
			current.right.position = current.position + Vector2(200, 0)
		else:
			current.right.position = current.position + Vector2(200, 100)
		draw_helper(current.right)
	if current.left != null:
		if current.right == null:
			current.left.position = current.position + Vector2(200, 0)
		else:
			current.left.position = current.position + Vector2(200, -100)
		draw_helper(current.left)
		print(end.position)
