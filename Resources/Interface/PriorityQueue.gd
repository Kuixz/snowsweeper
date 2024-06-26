class_name PriorityQueue
"""
Thanks to u/bigturtle for the priority queue implementation

Priority Queue. Min heap priority queue that can take a Vector2 and its
corresponding cost and then always return the Vector2 in it with
the lowest cost value.
Based on: https://en.wikipedia.org/wiki/Binary_heap
"""
var _data: Array = []

func head():
	return self._data[0]

func size():
	return len(_data)

func insert(element, cost: float) -> void:
	# Add the element to the bottom level of the heap at the leftmost open space
	self._data.push_back([cost, element])
	var new_element_index: int = self._data.size() - 1
	self._up_heap(new_element_index)

func extract():
	if self.empty():
		return null
	var result = self._data.pop_front()
	# If the tree is not empty, replace the root of the heap with the last
	# element on the last level.
	if not self.empty():
		self._data.push_front(self._data.pop_back())
		self._down_heap(0)
	return result[1]

func empty() -> bool:
	return self._data.is_empty()


# Dangerous!
func find_by(f: Callable):
	for item in _data:
		if f.call(item):
			return item

func override_data(arr: Array):
	self._data = arr

func erase(item):
	_data.erase(find_by(func(d): return d[1] == item))

func map(f: Callable) -> Array:
	return _data.map(func (entry): return f.call(entry[1]))



func _get_parent(index: int) -> int:
	@warning_ignore("integer_division")
	return (index - 1) / 2

func _left_child(index: int) -> int:
	return (2 * index) + 1

func _right_child(index: int) -> int:
	return (2 * index) +  2

func _swap(a_idx: int, b_idx: int) -> void:
	var c = self._data[a_idx]
	self._data[a_idx] = self._data[b_idx] 
	self._data[b_idx] = c

func _up_heap(index: int) -> void:
	# Compare the added element with its parent; if they are in the correct order, stop.
	var parent_idx = self._get_parent(index)
	if self._data[index][0] >= self._data[parent_idx][0]:
		return
	self._swap(index, parent_idx)
	self._up_heap(parent_idx)

func _down_heap(index: int) -> void:
	var left_idx: int = self._left_child(index)
	var right_idx: int = self._right_child(index)
	var smallest: int = index
	var size: int = size()

	if right_idx < size and self._data[right_idx][0] < self._data[smallest][0]:
		smallest = right_idx

	if left_idx < size and self._data[left_idx][0] < self._data[smallest][0]:
		smallest = left_idx

	if smallest != index:
		self._swap(index, smallest)
		self._down_heap(smallest)
