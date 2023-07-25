@tool
extends VBoxContainer

class_name BeatProgrammer
signal program_changed

var beatCountChanged = false
var currentBeat = 0
var checkboxGroups: Array[ButtonGroup]
@onready var checkboxScene=preload("res://beat_control_checkbox.tscn")
@export var bpm:int:
	set(new_bpm):
		bpm = new_bpm
		

@export var numSteps = 4:
	set(new_value):
		if new_value != numSteps:
			numSteps = new_value
			beatCountChanged=true
			checkboxGroups = []
			for i in range(1, numSteps+1):
				checkboxGroups.append(ButtonGroup.new())

# Called when the node enters the scene tree for the first time.
func _ready():
	if !Engine.is_editor_hint():
		get_tree().call_group("beat_checkbox","connect", "pressed", func():
			emit_signal("program_changed")
			)
		$BeatTimer.wait_time = 60.0 / float(bpm)
		$BeatTimer.timeout.connect(self.next_beat)
		$BeatTimer.start()


func next_beat():
	if Engine.is_editor_hint():
		$BeatTimer.stop()
	currentBeat = wrap(currentBeat+1, 1, numSteps+1)
	print(currentBeat)
	var combinedDirection = Vector2.ZERO
	var checkboxes = get_tree().get_nodes_in_group("Beat" + str(currentBeat))
	var player = get_tree().current_scene.playerNode
	move_indicator("Beat" + str(currentBeat))
	for cb in checkboxes:
		if cb.button_pressed:
			combinedDirection += cb.direction
			
	match combinedDirection:
		Vector2.UP:
			$AudioPlayers/Forward.play()
		Vector2.DOWN:
			$AudioPlayers/Back.play()
		Vector2.LEFT:
			$AudioPlayers/Left.play()
		Vector2.RIGHT:
			$AudioPlayers/Right.play()
	
	%Indicator.visible = true
	if is_instance_valid(player):
		player.move_in_direction(combinedDirection)

# Called every frame. 'delta' is the elapsed time since the previous frame.

func move_indicator(group):
	var first_column = get_tree().get_nodes_in_group(group)
	$Indicator.global_position.x = first_column[0].global_position.x + 10

func _process(delta):
	if Engine.is_editor_hint() and beatCountChanged:
		beatCountChanged = false
		populate_checkboxes()

func delete_checkboxes_in_container(container):
	for child in container.get_children():
		if child is CheckBox:
			child.queue_free()

func create_checkboxes(container, is_pressed, direction):
	for step in range(1,numSteps+1):
		var cb = checkboxScene.instantiate()
		cb.button_group = checkboxGroups[step-1]
		cb.direction = direction
		cb.button_pressed = is_pressed
		container.add_child(cb)
		cb.set_owner(get_tree().edited_scene_root)
		cb.add_to_group("Beat" + str(step),true)


func populate_checkboxes():
	for hbox in [$"Forward Controls", $"Left Controls", $"Right Controls", $"Backward Controls"]:
		delete_checkboxes_in_container(hbox)
		
	create_checkboxes($"Forward Controls",true, Vector2.UP)
	create_checkboxes($"Left Controls", false, Vector2.LEFT)
	create_checkboxes($"Right Controls", false, Vector2.RIGHT)
	create_checkboxes($"Backward Controls",false, Vector2.DOWN)
	move_indicator("Beat1")
