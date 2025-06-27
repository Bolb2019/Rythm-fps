extends CharacterBody2D
#class_name Player

var MOVE_SPEED = 0
var TURN_SPEED = 0.1
var time = 0
var able = true
var moving = false

func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	
	if GlobalPlayer.room_completed == GlobalPlayer.total_rooms - 1:
		print("winner :D")
		GlobalPlayer.total_rooms = 0
		GlobalPlayer.room_completed = 0
		get_tree().change_scene_to_file("res://Scenes/Main.tscn")
	
	
	if !GlobalPopup.pause:
		scale = Vector2(1 + MOVE_SPEED, MOVE_SPEED - 1).normalized() * 1.3
		
		time += delta
		
		if GlobalPlayer.dashes < GlobalPlayer.max_dashes && able:
			able = false
			refill_dash(2)
		
		if GlobalPlayer.health <= 0:
			get_tree().change_scene_to_file("res://Scenes/Main_Menu.tscn")
		
		GlobalPlayer.X_pos = global_position.x
		GlobalPlayer.Y_pos = global_position.y
		
		var vect : Vector2
		vect = get_global_mouse_position()

		# Get the input direction and handle the movement/deceleration.
		# As good practice, you should replace UI actions with custom gameplay actions.
		move_local_x(MOVE_SPEED)
		
		var directionX := Input.get_axis("D", "A")
		if directionX:
			rotation -= (directionX * TURN_SPEED)
			
		if Input.is_action_pressed("W"):
			if MOVE_SPEED < GlobalPlayer.max_speed:
				MOVE_SPEED += 0.3
			moving = true
		else:
			moving = false
			if MOVE_SPEED > 0:
				MOVE_SPEED -= 0.3
			else:
				MOVE_SPEED = 0
			
		if Input.is_action_just_pressed("Shift") && GlobalPlayer.dashes > 0 && moving:
			GlobalPlayer.dashes -= 1
			MOVE_SPEED *= 6
			#$HitBox.disabled = true
			$Dash.emitting = true
			stop_dash(0.3)

		move_and_slide()


func refill_dash(cooldown) -> void:
	await get_tree().create_timer(cooldown).timeout
	GlobalPlayer.dashes += 1
	able = true


func stop_dash(cooldown) -> void:
	await get_tree().create_timer(cooldown).timeout
	MOVE_SPEED /= 6
	#$HitBox.disabled = false
