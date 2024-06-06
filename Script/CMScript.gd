extends CanvasModulate

func _ready():
	self.color = Color(1, 1, 1)  # Ajusta el color y la intensidad de la luz global

func _getCurrentColor():
	return self.color

func _setColor(value):
	self.color = Color (value, value, value)
