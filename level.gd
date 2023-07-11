extends Node
class_name Level

@export var bpm = 120

# Called when the node enters the scene tree for the first time.
func _ready():
		BeatTimer.set_bpm(bpm)

