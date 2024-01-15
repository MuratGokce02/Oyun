extends Node

@export var nodes = []

func _ready():
	var node_temp := load("res://node.tscn")
	var root = node_temp.instantiate()
	var stack := [root]
	nodes.append(root)
	var lenght := randi_range(5, 7)
	var number_of_nodes = 1
	var last_nodes := []
	var prev_layer_nodes := 1
	var current_layer_nodes := 0
	print(lenght)


	for node in stack:
		if lenght != 0:
			stack.pop_front()
			prev_layer_nodes -= 1
			node.layer = lenght
			node.left = node_temp.instantiate()
			current_layer_nodes += 1
			number_of_nodes += 1
			stack.append(node.left)
			nodes.append(node.left)
			var random = randi_range(1,2)
			if random == 1:
				node.right = node_temp.instantiate()
				current_layer_nodes += 1
				number_of_nodes += 1
				stack.append(node.right)
				nodes.append(node.right)
			last_nodes.append(node)
			if prev_layer_nodes == 0:
				prev_layer_nodes = current_layer_nodes
				current_layer_nodes = 0
				lenght -= 1
				last_nodes.clear()
		else:
			break
	print(stack)

	var last_layer
	var counter = 0
	for node_instance in nodes:
		add_child(node_instance)
		node_instance.position.x = node_instance.layer * 100
		if last_layer == node_instance.layer:
			counter += 1
			node_instance.position.y = counter * 100
		last_layer = node_instance.layer

	print(number_of_nodes)


#func deneme():
#	for node in stack:
#		if lenght != 0:
#			node.left = node_temp.instantiate()
#			stack.append(node.left)
#			var random = randi_range(1, 2)
#			if random == 2:
#				node.right = node_temp.instantiate()
#				stack.append(node.right)
#		else:
#			break
