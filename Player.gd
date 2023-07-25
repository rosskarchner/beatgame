extends CharacterBody2D

var destination: Vector2
var listening = false
var moving = false

@onready var starting_position = global_position

signal died
signal restored

func _ready():
	listening = true

func _physics_process(delta):
	if position == destination:
		moving = false
	
	if listening and moving: 
		velocity = destination - position
		var collision = move_and_collide(velocity * delta * 64)
		if collision:
			start_death()
		
func start_death():
	listening = false
	emit_signal("died")
	$AnimationPlayer.play('die')
	
	
func move_in_direction(direction):
	if listening:
		destination = position + (direction*64)
		moving=true

func go_home():
	moving = false
	destination = Vector2.ZERO
	global_position=starting_position
	$AnimationPlayer.play("appear")

func restore():
	listening = true
	emit_signal("restored")


func _on_visible_on_screen_notifier_2d_screen_exited():
	start_death()
	
