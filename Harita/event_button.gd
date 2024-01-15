extends Button


var rewards
func _on_pressed():
	PlayerVariables.gold += rewards
	PlayerVariables.runtime = false
	find_parent("UI").get_child(0).queue_free()
