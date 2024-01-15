extends Control

var id
var path_id
var parent := []
var children = []
var distance = 0
var weight = 0
var type
var active = false
var not_passed = true
var double_entry = false


func set_type(type_setting):
	type = type_setting
	if type_setting == "fight":
		get_child(0).get_child(0).texture_normal = load("res://swords.png")
	elif type_setting == "treasure":
		get_child(0).get_child(0).texture_normal = load("res://treasure-chest.png")
	elif  type_setting == "event":
		get_child(0).get_child(0).texture_normal = load("res://question.png")
	elif type_setting == "boss":
		get_child(0).get_child(0).texture_normal = load("res://skull.png")


func hide_node():
	get_child(0).get_child(0).modulate = Color(1,1,1,0.5)


func activate_node():
	if type == "fight":
		get_child(0).get_child(0).texture_normal = load("res://swords_highlight.png")
	elif type == "treasure":
		get_child(0).get_child(0).texture_normal = load("res://treasure-chest_highlight.png")
	elif  type == "event":
		get_child(0).get_child(0).texture_normal = load("res://question_highlight.png")
	get_child(0).get_child(0).disabled = false


func deactivate_node():
	if type == "fight":
		get_child(0).get_child(0).texture_normal = load("res://swords.png")
	elif type == "treasure":
		get_child(0).get_child(0).texture_normal = load("res://treasure-chest.png")
	elif  type == "event":
		get_child(0).get_child(0).texture_normal = load("res://question.png")
	get_child(0).get_child(0).disabled = true


func _on_texture_button_pressed():
	PlayerVariables.change_current(self)
	if type == "event":
		get_tree().root.get_child(1).find_child("UI").add_child(load("res://event_panel.tscn").instantiate())
		PlayerVariables.runtime = true
