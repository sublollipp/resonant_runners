extends Node2D

var warning : String = ""

@export var button1 : rrButton:
	set(nb):
		button1 = nb
		checkButtonsForWarning()
@export var button2 : rrButton:
	set(nb):
		button2 = nb
		checkButtonsForWarning()
		
		
func checkButtonsForWarning() -> void:
	if button1 == button2:
		if button1 == null || button2 == null:
			warning = "Set two buttons to make this work"
		else:
			warning = "You have put the same button, twice"
	update_configuration_warnings()

func _get_configuration_warnings() -> PackedStringArray:
	return [warning]

func checkForOpening() -> void:
	if button1.pressed && button2.pressed:
		openDoor()

func _ready() -> void:
	GDSync.expose_func(dontUseThisFunction)
	
	for b : rrButton in [button1, button2]:
		if not b.buttonPressed.is_connected(Callable(self, "checkForOpening")):
			b.buttonPressed.connect(Callable(self, "checkForOpening"))
		if not b.connected_node == self:
			b.connected_node == self

func dontUseThisFunction():
	queue_free()

func openDoor() -> void:
	GDSync.call_func(dontUseThisFunction)
	dontUseThisFunction()
