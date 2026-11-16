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
			new_textbox.speaker = 'little NPC'
			new_textbox.text = [
		'Hello, friend. My name is Nickel-us Phosphorus Carbon, but you can just call me NPC.',
		'Where\'s your friend you ask? Answer my riddle first.',
		'What has to be broken before you can use it?','//text egg','I don\'t know where George is. Although, I remember his favourite animal is a ‘sea bunny’, but of course the real answer has to be me.']
			
			%TextboxContainer.add_child(new_textbox)
			get_tree().paused = true
