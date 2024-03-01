extends Area2D

@export var room_cam: PhantomCamera2D

static var current_room_cam: PhantomCamera2D

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	
	get_parent().process_mode = Node.PROCESS_MODE_DISABLED
	process_mode = Node.PROCESS_MODE_ALWAYS
	
	await get_tree().physics_frame
	
	for i in get_overlapping_bodies():
		if i is Player:
			_on_player_entered()

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		_on_player_entered()

func _on_body_exited(body: Node2D) -> void:
	if body is Player:
		_on_player_exited()

func _on_player_entered() -> void:
	get_parent().process_mode = Node.PROCESS_MODE_INHERIT
	
	if room_cam:
		if is_instance_valid(current_room_cam):
			current_room_cam.set_priority(0)
			
		room_cam.set_priority(5)
		current_room_cam = room_cam

func _on_player_exited() -> void:
	get_parent().process_mode = Node.PROCESS_MODE_DISABLED
