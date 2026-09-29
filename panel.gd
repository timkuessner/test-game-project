extends Panel


func updateHerz(x):
	if x <= 0:
		$TextureRect.show()
		$TextureRect3.hide()
		$TextureRect2.hide()
	elif x == 1:
		$TextureRect.hide()
		$TextureRect3.show()
		$TextureRect2.hide()
	else:
		$TextureRect.hide()
		$TextureRect3.hide()
		$TextureRect2.show()
	
		
