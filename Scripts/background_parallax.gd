extends Node2D

var parallax : float = 0.7
@onready var player = $"../Player"

func _process(delta):
    global_position.x = player.global_position.x * parallax