@tool
extends VBoxContainer

class_name BeatProgrammer
signal program_changed

var beatCountChanged = false
var currentBeat = 0
@onready var checkboxScene=preload("res://beat_control_checkbox.tscn")


@export var numSteps = 4:
	set(new_value):
		if new_value != numSteps:
			numSteps = new_value
			beatCountChanged=true
		
@export_group("Default Program")
@export  var forward_program: Array[bool] = [false, false, false, false,false, false, false, false]
@export  var left_program: Array[bool] = [false, false, false, false,false, false, false, false]
@export  var right_program: Array[bool] = [false, false, false, false,false, false, false, false]
@export  var backward_program: Array[bool] = [false, false, false, false,false, false, false, false]


# Called when the node enters the scene tree for the first time.
func _ready():
	get_tree().call_group("beat_checkbox","connect", "pressed", func():
		emit_signal("program_changed")
		)
	BeatTimer.timeout.connect(self.next_beat)


func next_beat():
	currentBeat = wrap(currentBeat+1, 1, numSteps+1)
	var combinedDirection = Vector2.ZERO
	var checkboxes = get_tree().get_nodes_in_group("Beat" + str(currentBeat))
	for cb in checkboxes:
		if cb.button_pressed:
			combinedDirection += cb.direction
	
	%Indicator.offset.x = (currentBeat-1) * 28
	%Indicator.visible = true
	%Player.move_in_direction(combinedDirection)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if beatCountChanged:
		beatCountChanged = false
		populate_checkboxes()

func delete_checkboxes_in_container(container):
	for child in container.get_children():
		if child is CheckBox:
			child.queue_free()

func create_checkboxes(container, defaults, direction):
	for step in range(1,numSteps+1):
		var cb = checkboxScene.instantiate()
		cb.direction = direction
		cb.button_pressed = defaults[step-1]
		container.add_child(cb)
		cb.set_owner(get_tree().edited_scene_root)
		cb.add_to_group("Beat" + str(step),true)


func populate_checkboxes():
	for hbox in [$"Forward Controls", $"Left Controls", $"Right Controls", $"Backward Controls"]:
		delete_checkboxes_in_container(hbox)
		
	create_checkboxes($"Forward Controls",forward_program, Vector2.UP)
	create_checkboxes($"Left Controls", left_program, Vector2.LEFT)
	create_checkboxes($"Right Controls", right_program, Vector2.RIGHT)
	create_checkboxes($"Backward Controls",backward_program, Vector2.DOWN)
