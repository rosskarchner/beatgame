extends Node

@export var levels: Array[PackedScene]
var current_level = 0

func go_next_level():
		print("next level!")
		current_level +=1
		get_tree().change_scene_to_packed(levels[current_level])
