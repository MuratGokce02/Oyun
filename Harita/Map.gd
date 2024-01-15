extends Tree


func _ready():
	var map := Tree.new()
	var start_node = map.create_item()
	var node := load("res://icon.svg")
	print(node)
	var node1 = map.create_item(start_node)
	var node2 = map.create_item(start_node)
	node1.set_text(0, "lol")
	node2.set_text(0, "lol2")
	map.set_column_title(0,"lolstart")
	node1.set_icon(0, node)

func generate_nodes():
	return
