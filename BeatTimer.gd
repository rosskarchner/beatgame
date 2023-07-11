extends Timer


func set_bpm(bpm):
	wait_time = 60.0 / float(bpm)
	start()
