extends Node


@onready var playerNode = $Player


# Called when the node enters the scene tree for the first time.
func _ready():
	
		$BeatProgrammer.program_changed.connect(func():
			reset_beats()
			playerNode.go_home()
			)
		$Player.died.connect(self.handle_player_death)

		reset_beats()
		
		

func handle_player_death():
	reset_beats()
	
	
func reset_beats(_arg=null):
	$BeatProgrammer/BeatTimer.stop()
	$BeatProgrammer.currentBeat = 0
	$BeatProgrammer/Button.disabled = false
	

func start():
	playerNode.go_home()
	$BeatProgrammer/BeatTimer.start()

	
func _physics_process(delta):
	pass

func _unhandled_input(event):
	if event.is_action_pressed("reset"):
		reset_beats()
		


func _on_beat_programmer_property_list_changed():
	pass # Replace with function body.


func _on_button_pressed():
	$BeatProgrammer/Button.disabled = true
	start()

