extends Panel


var events = ["res://event_1.gd","res://event_2.gd"]


func _ready():
	var event = load(select_event()).new()
	find_child("EventText").text = event.text
	for choices in range(event.choices.size()):
		var new_button = load("res://event_button.tscn").instantiate()
		get_child(0).add_child(new_button)
		new_button.text = event.choices[choices]
		new_button.rewards = event.rewards


func select_event():
	var random_event_id = randi_range(0, events.size() - 1)
	return events[random_event_id]
