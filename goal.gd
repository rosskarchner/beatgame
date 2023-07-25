extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_area_2d_area_entered(area):
	area.get_parent().listening=false
	get_tree().current_scene.reset_beats()
	$AnimationPlayer.play("win")
	$AudioStreamPlayer.play()
	



func _on_animation_player_animation_finished(anim_name):
	LevelManager.go_next_level()
