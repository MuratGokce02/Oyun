extends Node


var current_node
var health = 100
var gold = 0
var runtime = false


func change_current(node):
	if not runtime:
		if current_node != null:
			for child in current_node.children:
				child.deactivate_node()
			current_node.hide_node()
		current_node = node
		for child in current_node.children:
			child.activate_node()
