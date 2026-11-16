extends CanvasLayer

const dates = {["06","15","2875"]: "intro", ["04", "18", "2393"]: "level_1", ["01", "30", "2086"]: "level_2", ["11", "15", "2026"]: "outro
"}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	%DateLabel.text = "%s/%s/%s" % Global.current_date


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _open_time_machine() -> void:
	%PopupPanel.popup_centered()
	%Incorrect.visible = false

func _on_submit_pressed() -> void:
	var day = %DayLine.text
	var month = %MonthLine.text
	var year = %YearLine.text
	var date = [month, day, year]
	
	if date in dates:
		%PopupPanel.hide()
		print(dates[date])
		Global.current_date = date
		%DateLabel.text = "%s/%s/%s" % date
		get_tree().change_scene_to_file("res://%s.tscn" % dates[date])
		%Player._respawn()
	else:
		%Incorrect.visible = true
