class_name SelectComponent
extends Node2D


signal selected
signal deselected


@export var selection_indicator: Node2D
@export_enum("Deselected", "Selected") var initial_state := "Deselected"


func _ready():
	SelectManager.register(self)
	if selection_indicator:
		selection_indicator.visible = initial_state == "Selected"


func select():
	emit_signal("selected")
	if selection_indicator: 
		selection_indicator.visible = true
	


func deselect():
	emit_signal("deselected")
	if selection_indicator: 
		selection_indicator.visible = false
