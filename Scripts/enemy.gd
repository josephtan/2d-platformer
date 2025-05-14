extends Area2D

@export var move_direction : Vector2
@export var move_speed : float = 40

@onready var start_pos : Vector2 = global_position
@onready var target_pos : Vector2 = global_position + move_direction


func _physics_process(delta):
    global_position = global_position.move_toward(target_pos, move_speed * delta)

    if global_position == target_pos:
        if target_pos == start_pos:
            target_pos = global_position + move_direction
        else:
            target_pos = start_pos
