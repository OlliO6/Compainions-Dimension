class_name Player
extends CharacterBody2D

signal jumped

@export var movement_speed: float = 10
@export var jump_velocity: float = 10
@export_range(0, 1) var acceleration: float = 0.5
@export_range(0, 1) var deceleration: float = 0.5
@export_range(0, 1) var air_acceleration: float = 0.5
@export_range(0, 1) var air_deceleration: float = 0.5
@export var gravity: float = 10
@export var jump_gravity: float = 6
@export_range(0, 1) var jump_cancel_strenght: float = 0.5

@onready var state_machine: StateMachine = $StateMachine
@onready var idle_state: State = $StateMachine/Idle
@onready var run_state: State = $StateMachine/Run
@onready var jump_state: State = $StateMachine/Jump
@onready var fall_state: State = $StateMachine/Fall
@onready var bounce_state: State = $StateMachine/Bounce

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var jump_buffer_timer: Timer = $JumpBuffer
@onready var jump_lenience_timer: Timer = $JumpLenience

func _physics_process(delta: float) -> void:
	
	match state_machine.state:
		idle_state:
			if _move_horizontal(0, acceleration, deceleration, delta) != 0:
				state_machine.switch_state(run_state)
			_grounded()
			
		run_state:
			var input:= _move_horizontal(movement_speed, acceleration, deceleration, delta)
			if input == 0:
				state_machine.switch_state(idle_state)
			else:
				animated_sprite.flip_h = input < 0
			_grounded()
		
		fall_state:
			velocity.y += gravity * delta
			if abs(velocity.x) > 0.01:
				animated_sprite.flip_h = velocity.x < 0
			if !jump_buffer_timer.is_stopped() && !jump_lenience_timer.is_stopped():
				jump()
			if is_on_floor():
				state_machine.switch_state(idle_state)
				$LandSound.play()
			_move_horizontal(movement_speed, air_acceleration, air_deceleration, delta)
		
		jump_state:
			velocity.y += jump_gravity * delta
			if !Input.is_action_pressed("jump"):
				velocity.y = velocity.y * (1 - jump_cancel_strenght)
				state_machine.switch_state(fall_state)
			if velocity.y > 0:
				state_machine.switch_state(fall_state)
			_move_horizontal(movement_speed, air_acceleration, air_deceleration, delta)
		
		bounce_state:
			velocity.y += jump_gravity * delta
			if velocity.y > 0:
				state_machine.switch_state(fall_state)
			_move_horizontal(movement_speed, air_acceleration, air_deceleration, delta)
	
	move_and_slide()

func _unhandled_input(event: InputEvent) -> void:
	if !event.is_echo() && event.is_action_pressed("jump"):
		jump_buffer_timer.start()

func bounce(velo: float) -> void:
	jump_buffer_timer.stop()
	jump_lenience_timer.stop()
	velocity.y = -velo
	state_machine.switch_state(bounce_state)
	$JumpSound.play()

func jump() -> void:
	jump_buffer_timer.stop()
	jump_lenience_timer.stop()
	velocity.y = -jump_velocity
	state_machine.switch_state(jump_state)
	jumped.emit()
	$JumpSound.play()
	
# returns horizontal input
func _move_horizontal(speed: float, accel: float, decel, delta: float) -> float:
	var input:= Input.get_axis("left", "right")
	var accelerate: bool = sign(input) == sign(velocity.x) && abs(input) > abs(velocity.x)
	velocity.x = lerp(velocity.x, speed * input, accel if accelerate else decel)
	return input

func _grounded() -> void:
	velocity.y = 1
	if !is_on_floor():
		jump_lenience_timer.start()
		state_machine.switch_state(fall_state)
	
	if !jump_buffer_timer.is_stopped():
		jump()

func _on_state_machine_state_switched(to_state: State, from_state: State) -> void:
	pass
