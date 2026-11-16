extends CharacterBody2D


const SPEED = 600.0
const JUMP_VELOCITY = -400.0

@export var texture_front: Texture2D
@export var texture_left: Texture2D
@export var texture_right: Texture2D

@export var teleport_destination: Node2D

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	# fly
	if Input.is_action_just_pressed("ui_accept") and not is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
		# switch
		if direction > 0:
			$Sprite2D.texture = texture_right
		else:
			$Sprite2D.texture = texture_left
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		# reset
		$Sprite2D.texture = texture_front

	move_and_slide()
	
	# checking collision
	check_tile_teleport()

func check_tile_teleport() -> void:
	if not teleport_destination:
		return
		
	#for i in get_slide_collision_count():
		#var collision := get_slide_collision(i)
		#var collider := collision.get_collider()
		#
		#if collider is TileMapLayer:
			## nudge collision so it isn't only considering inside the block
			#var hit_pos := collision.get_position() - collision.get_normal()
			#var tile_coords: Vector2i = collider.local_to_map(collider.to_local(hit_pos))
			#var tile_data: TileData = collider.get_cell_tile_data(tile_coords)
			#
			#if tile_data and tile_data.get_custom_data("is_teleporter") == true:
				#global_position = teleport_destination.global_position
				#velocity = Vector2.ZERO # reset momentum
				#break
				
	for i in get_slide_collision_count():
		var collision := get_slide_collision(i)
		var collider := collision.get_collider()
		if collider.get_parent().is_in_group("teleporter"):
			global_position = teleport_destination.global_position
			velocity = Vector2.ZERO

			
