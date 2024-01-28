extends Object
class_name CellData

var flagged: bool = false
var revealed: bool = false
var isMine: bool = false
var number: int

func _init(f = false, r = false, i = false, n = -1):
	flagged = f
	revealed = r
	isMine = i
	number = n
