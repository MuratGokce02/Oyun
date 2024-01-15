extends CanvasItem


var start
var end
var all_nodes = []
var id = 0
var path_id = 0
var off_set = Vector2(-64, -64)
@onready var node_temp = load("res://node.tscn")


func _ready():
	var init_length = randi_range(6, 8)
	start = create_node(0)
	start.set_type("fight")
	end = create_node()
	var prev_node_right = start
	var prev_node_left = start
	for layer in range(init_length):
		var new_right = create_node()
		var new_left = create_node()
		connect_nodes(prev_node_right, new_right)
		connect_nodes(prev_node_left, new_left)
		prev_node_right = new_right
		prev_node_left = new_left
	connect_nodes(prev_node_right, end)
	connect_nodes(prev_node_left, end)
	var random_roads = randi_range(1, 3)
	for road in range(random_roads):
		var road_start = all_nodes[randi_range(2, all_nodes.size() - 1)]
		while road_start in end.parent:
			road_start =  all_nodes[randi_range(2, all_nodes.size() - 1)]
		var max_lenght = end.distance - road_start.distance 
		var road_lenght = randi_range(max_lenght - 1 , max_lenght)
		var road_end = road_start
		for node in range(road_lenght):
			if road_end != end:
				road_end = get_node_child(road_end)
		if road_end.distance - road_start.distance != 0:
			create_path(road_start, road_end)
	weight_counter(start)
	set_types(start)
	end.set_type("boss")
	draw()
	get_child(0).position = start.position + Vector2(800, 0)
	PlayerVariables.change_current(start)
	set_player_position()


func create_node(_path_id = null):
	var new_node = node_temp.instantiate()
	new_node.id = id
	id += 1
	new_node.path_id = _path_id
	all_nodes.append(new_node)
	add_child(new_node)
	return new_node


func connect_nodes(parent, child):
	parent.children.append(child)
	child.parent.append(parent)
	var child_distance = 0
	for other_parent in child.parent:
		if other_parent.distance > child_distance:
			child_distance = other_parent.distance
	child.distance = child_distance + 1
	if child.parent.size() == 2:
		child.double_entry = true
	return child


func create_path(path_start, path_end):
	path_id += 1
	var path_length = abs(path_end.distance - path_start.distance) - 1 + randi_range(-1, 1)
	var last_node = path_start
	for node in range(path_length):
		last_node = connect_nodes(last_node, create_node(path_id))
	connect_nodes(last_node, end)
	return


func set_types(current):
	for child in current.children:
		if current.type == "fight":
			var type_randomizer = randi_range(1, 10)
			if type_randomizer <= 4:
				child.set_type("fight")
				set_types(child)
			elif type_randomizer > 4 and type_randomizer <= 7:
				child.set_type("treasure")
				set_types(child)
			elif type_randomizer > 7:
				child.set_type("event")
				set_types(child)
		if current.type == "treasure":
			var type_randomizer = randi_range(1, 10)
			if type_randomizer <= 7:
				child.set_type("fight")
				set_types(child)
			elif type_randomizer > 7 and type_randomizer <= 8:
				child.set_type("treasure")
				set_types(child)
			elif type_randomizer > 8:
				child.set_type("event")
				set_types(child)
		if current.type == "event":
			var type_randomizer = randi_range(1, 10)
			if type_randomizer <= 7:
				child.set_type("fight")
				set_types(child)
			elif type_randomizer > 7 and type_randomizer <= 9:
				child.set_type("treasure")
				set_types(child)
			elif type_randomizer > 9:
				child.set_type("event")
				set_types(child)


func get_node_child(node):
	return node.children[0]


#game section


func set_player_position():
	var current = PlayerVariables.current_node
	current.get_child(0).get_child(0).texture_normal = load("res://helmet.png")
	for child in current.children:
		child.activate_node()


#drawing section


func draw():
	var center = get_viewport().get_visible_rect().get_center()
	var length = get_viewport().get_visible_rect().size.x
	start.position = center - Vector2(length/2 - length * 1/20, 0)
	draw_helper3(start)
	parental_centering(start)
	parental_pushing(start)


func draw_helper(current):
	var children = current.children
	for node in children:
		if node.parent.size() <= 1:
			node.position = current.position + Vector2(300, 0) + Vector2(0, children.find(node) * 300) - Vector2(0, ((float(children.size() - 1)) / 2 * 300))
		else:
			var parents_sum = 0
			var farthest_parent = 0
			for parent in node.parent:
				parents_sum = parent.position.y + parents_sum
				if parent.position.x > farthest_parent:
					farthest_parent = parent.position.x
			node.position = Vector2(300 + farthest_parent, parents_sum / node.parent.size())
		draw_helper(node)
	return


func draw_helper3(current):
	var first_child
	var last_child
	if current.children.size() != 0:
		first_child = current.children[0]
	var children_a
	var children_b
	if current.children.size() == 1:
		first_child.position = current.position + Vector2(300, 0)
		draw_helper3(first_child)
		return
	for child in current.children:
		if child == first_child:
			child.position = current.position + Vector2(300, 0)
			children_a = child.weight
			last_child = child
			draw_helper3(child)
			continue
		children_b = child.weight
		child.position = last_child.position + Vector2(0, 300) * (float(children_a - 1)/2 + float(children_b - 1)/2 + 1)
		children_a = child.weight
		last_child = child
		draw_helper3(child)
	draw_finisher(current)


func draw_finisher(current):
	var first_child
	if current.children.size() != 0:
		first_child = current.children[0]
	for child in current.children:
		draw_finisher_helper(child, Vector2(0, 300) * float(current.weight - first_child.weight)/2)


func draw_finisher_helper(child, position_increase):
	child.position -= position_increase
	for grand_child in child.children:
		draw_finisher_helper(grand_child, position_increase)


func parental_centering(current):
	for child in current.children:
		if child.parent.size() > 1:
			var highest_parent = child.parent[0].position.y
			var lowest_parent = child.parent[0].position.y
			for parent in child.parent:
				if parent.position.y < highest_parent:
					highest_parent = parent.position.y
				if parent.position.y > lowest_parent:
					lowest_parent = parent.position.y
			#print([highest_parent, lowest_parent])
			var change = (highest_parent - lowest_parent) / 2
			#print(change)
			child.position.y = lowest_parent + change
			move_children(child, change)
		parental_centering(child)


func parental_pushing(current):
	for child in current.children:
		var farthest_parent_x = child.position.x
		for parent in child.parent:
			if farthest_parent_x <= parent.position.x:
				farthest_parent_x = parent.position.x
				child.position.x = farthest_parent_x + 300
		parental_pushing(child)


func move_children(parent, movement):
	for child in parent.children:
		child.position.y -= movement 


func draw_helper2(current):
	var last_weight_sum = 0
	#var parent_weights = 0
	for child in current.children:
		#for parent in child.parent:
			#parent_weights += parent.weight
		child.position = Vector2(0, current.position.y) + Vector2(300 * child.distance, 0) + Vector2(0, last_weight_sum * 300) - Vector2(0, float(current.weight - 1) / 2 * 300)
		last_weight_sum += child.weight
		draw_helper2(child)


func weight_counter(current):
	if current.children.size() == 0:
		current.weight = 1
		current.find_child("Type").text = str(current.weight)
		return
	for child in current.children:
		if child.parent.size() < 2 or child.weight == 0:
			weight_counter(child)
		current.weight += child.weight
		current.find_child("Type").text = str(current.weight)
		if child == end:
			current.find_child("Type").text = "end"


#linework section


func _draw():
	line_work(start)


func line_work(current):
	for child in current.children:
		draw_line(current.position - off_set, child.position - off_set, Color(randf_range(0, 1) ,randf_range(0, 1) ,randf_range(0, 1) , 0.5), 10, true)
		line_work(child)
