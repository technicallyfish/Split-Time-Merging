extends CharacterBody2D

signal open_time_machine
signal talk_to_npc

const SPEED = 50.0
const JUMP_VELOCITY = -600.0
const LIFT_VELOCITY = [36.0,25.0]
const MAX_JUMPS = 1
const JUMP_WINDOW = 0.2
var jump_time = 0
var jumps = MAX_JUMPS

var gamemode = 'rocket'


@export var texture_front: Texture2D
@export var texture_left: Texture2D
@export var texture_right: Texture2D

@export var teleport_destination: Node2D
const TEXTBOX = preload("res://text_box.tscn")

func _ready() -> void:
	%DeathScreen.visible = false

func _physics_process(delta: float) -> void:
	#if Input.is_action_just_pressed("change_mode"):
		#gamemode = 'normal' if gamemode != 'normal' else 'jetpack'
	
	if gamemode == 'normal':
		var gravity_multi = 3
		# Add the gravity.
		if is_on_floor():
			jumps = MAX_JUMPS
			jump_time = 0
		else:
			velocity += get_gravity() * gravity_multi * delta
		
		# Handle jump.
		if Input.is_action_just_pressed("up") and jumps > 0:
			if not is_on_floor():
				jumps -= 1
			
			velocity.y = JUMP_VELOCITY
			jump_time = delta
			
		if jump_time < JUMP_WINDOW:
			if Input.is_action_pressed("up"):
				velocity.y = JUMP_VELOCITY
				jump_time += delta
			else:
				jump_time = JUMP_WINDOW
				
	else:
		var gravity_multi = 1
		
		if not is_on_floor():
			velocity += get_gravity() * delta
			
		if Input.is_action_pressed("up"):
			velocity.y -= LIFT_VELOCITY[0] if velocity.y >= 0 else LIFT_VELOCITY[1]

	var accel = Input.get_axis("left", "right")
	velocity.x += accel * SPEED
	velocity.x *= 0.9
	if abs(velocity.x) < 15: velocity.x = 0
	if accel:
		# switch
		if accel > 0:
			$Sprite2D.texture = texture_right
		else:
			$Sprite2D.texture = texture_left
	else:
		# reset
		$Sprite2D.texture = texture_front

	move_and_slide()

	var tm_interaction_range = %TimeMachineBox.get_overlapping_bodies()
	for body in tm_interaction_range:
		if body.name == "Player" and Input.is_action_just_pressed("open_time_machine"):
			open_time_machine.emit()
	
	var disable_rocket = %no_fly.get_overlapping_bodies()
	
	for body in disable_rocket:
		if body.name == "Player":
			gamemode = "normal"
	
	check_tile_teleport()

func _respawn() -> void:
	# go to global position
	global_position = %teleport_player.global_position
	velocity = Vector2.ZERO
	_ready()
	# Replace with function body.
	
func check_tile_teleport() -> void:
				
	for i in get_slide_collision_count():
		var collision := get_slide_collision(i)
		var collider := collision.get_collider()
		if collider.get_parent().is_in_group("teleporter"):
			%DeathScreen.visible = true
