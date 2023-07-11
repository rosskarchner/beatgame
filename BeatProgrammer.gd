@tool
extends VBoxContainer

class_name BeatProgrammer

@export var numSteps = 4:
	set(new_value):
		numSteps = new_value
		populate_checkboxes()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func delete_checkboxes_in_container(container):
	for child in container.get_children():
		if child is CheckBox:
			child.queue_free()

func populate_checkboxes():
	for hbox in [$"Forward Controls", $"Left Controls", $"Right Controls", $"Backward Controls"]:
		delete_checkboxes_in_container(hbox)
		for i in range(1,numSteps):
			var cb = CheckBox.new()
			hbox.add_child(cb)
