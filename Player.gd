extends CharacterBody2D

var destination = Vector2.ZERO
var listening = false

@onready var starting_position = position


func _physics_process(delta):
	velocity = destination - position
	if listening: 
		var collision = move_and_collide(velocity * delta * 64)
		if collision:
			start_death()
		
	
func start_death():
	listening = false
	%BeatTimer.stop()
	$AnimationPlayer.play('die')
	
func actually_dead():
	%BeatTimer.stop()
	queue_free()
	
func move_in_direction(direction):
	if listening:
		destination = position + (direction*64)

func reset():
	scale=Vector2(1,1)
	position=starting_position
	destination = starting_position
	listening = true


func _on_visible_on_screen_notifier_2d_screen_exited():
	start_death()
