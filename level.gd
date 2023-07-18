extends Node


@export var nextLevel: PackedScene

var playerScene=preload("res://player.tscn")

var playerNode: Node

# Called when the node enters the scene tree for the first time.
func _ready():
		$BeatProgrammer.program_changed.connect(self.reset)
		reset()

func reset(_arg=null):
	if not is_instance_valid(playerNode):
		var new_player = playerScene.instantiate()
		playerNode = new_player
		add_child(new_player)
		
	playerNode.listening = false
	$BeatProgrammer/BeatTimer.stop()
	$BeatProgrammer.currentBeat = 0
	playerNode.reset()
	$BeatProgrammer/BeatTimer.start()
	
func _physics_process(delta):
	pass

func _unhandled_input(event):
	if event.is_action_pressed("reset"):
		reset()
		
