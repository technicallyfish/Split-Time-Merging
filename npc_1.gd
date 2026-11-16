extends Sprite2D

const TEXTBOX = preload("res://text_box.tscn")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var npc_interaction_range = %npc_box.get_overlapping_bodies()
	for body in npc_interaction_range:
		if (body.name == "Player") and Input.is_action_just_pressed("talk_to_npc"):
			var new_textbox = TEXTBOX.instantiate()
			new_textbox.speaker = 'NPC'
			new_textbox.text = [
		'Hello, traveller. My name is Nickel-us Phosphorus Carbon, but you can just call me NPC.',
		'Where\'s your friend you ask? Answer my riddle first.',
		'What gets wet while drying?','//text towel','I don’t know where George is, but I do remember his favourite food was ‘potato chips.’']
			
			%TextboxContainer.add_child(new_textbox)
			get_tree().paused = true
