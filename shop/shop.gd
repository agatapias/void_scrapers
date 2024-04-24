extends Resource

class_name Shop

signal update
signal open


func openView(pInv, mInv):
	open.emit(pInv, mInv)
