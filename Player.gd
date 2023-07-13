extends CharacterBody2D

var destination = Vector2.ZERO
var listening = true

@onready var starting_position = position


func _physics_process(delta):
	velocity = destination - position
	if listening: move_and_collide(velocity * delta * 50)
	
func move_in_direction(direction):
	if listening:
		destination = position + (direction*50)

func reset():
	position=starting_position
	destination = starting_position
	listening = true
