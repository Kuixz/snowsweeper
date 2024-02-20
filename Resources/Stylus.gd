extends Resource
class_name Stylus


func save(content: Dictionary):
	var save_file = FileAccess.open("res://save_game.dat", FileAccess.WRITE)
	var json_string = JSON.stringify(content)
	save_file.store_line(json_string)

func load():
	if not FileAccess.file_exists("res://save_game.dat"):
		return # Error! We don't have a save to load.
		
	var save_file = FileAccess.open("res://save_game.dat", FileAccess.READ)
	var json_string = save_file.get_line()
	var json = JSON.new()
	var parse_result = json.parse(json_string)
	if not parse_result == OK:
		print("JSON Parse Error: ", json.get_error_message(), " in ", json_string, " at line ", json.get_error_line())
		return
#	print("Got data!")
	#print(json.get_data())
	return json.get_data()

#Upgrade to binary serialization later
#func save(content):
#	file.store_string(content)
#
#func close():
#	file.close()
#
#func load():
#	var content = file.get_as_text()
#	return content
