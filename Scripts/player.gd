extends CharacterBody2D

signal OnUpdateHealth (health : int)
signal OnUpdateScore (score : int)

@export var move_speed : float = 100
@export var acceleration : float = 50
@export var breaking : float = 20
@export var gravity : float = 400
@export var jump_force : float = 200

@export var health : int = 3

var move_input :float

@onready var sprite : Sprite2D = $Sprite
@onready var anim : AnimationPlayer = $AnimationPlayer

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta


	#move left and right
	move_input = Input.get_axis("move_left", "move_right")

	##movement
	if move_input != 0:
		velocity.x = lerp(velocity.x, move_input * move_speed, acceleration * delta)
	else:
		velocity.x = lerp(velocity.x, 0.0, breaking * delta)

	#jump

	if Input.is_action_pressed("jump") and is_on_floor():
		velocity.y = -jump_force
	else:
		velocity.y += gravity * delta

	#apply acceleration and breaking
	move_and_slide()

func _process(_delta):
	if velocity.x != 0:
		sprite.flip_h = velocity.x > 0
		_manage_animation()
	
	if global_position.y > 200:
		call_deferred("game_over")
	

func _manage_animation():
	if not is_on_floor():
		anim.play("jump")
	elif move_input != 0:
		anim.play("move")
	else:
		anim.play("idle")
		
func take_damage (amount : int):
	health -= amount
	OnUpdateHealth.emit(health)

	if health <= 0:
		call_deferred("game_over")	

func game_over():
	get_tree().change_scene_to_file("res://Scenes/level_1.tscn")

func increase_score(amount : int):
	PlayerStats.score += amount
	OnUpdateScore.emit(PlayerStats.score)

func _damage_flah(amount : int):
	sprite.modulate = Color.RED
	await get_tree().create_timer(0.05).timeout