extends Node
class_name Level

@export var bpm = 120


# Called when the node enters the scene tree for the first time.
func _ready():
		$BeatProgrammer.program_changed.connect(self.reset)
		BeatTimer.set_bpm(bpm)

func reset(_arg=null):
	$Player.listening = false
	BeatTimer.stop()
	$BeatProgrammer.currentBeat = 0
	$Player.reset()
	BeatTimer.start()
