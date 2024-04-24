extends Control
class_name ProgressCircle

var max_value:
	set(x):
		$ProgressCircle.max_value = x
	get:
		return $ProgressCircle.max_value

var value:
	set(x):
		$ProgressCircle.value = x
		var remaining = int(max_value - x)
		var fstring = "%d"
		var values = []
		if remaining >= 86400: 
			values.push_back(remaining / 86400)
			fstring += ":%02d"
		if remaining >= 3600: 
			values.push_back(remaining / 3600 % 24)
			fstring += ":%02d"
		if remaining >= 60: 
			values.push_back(remaining / 60 % 60)
			fstring += ":%02d"
		values.push_back(remaining % 60)
		var text = fstring % values
		$Label.text = text
	get:
		return $ProgressCircle.value
