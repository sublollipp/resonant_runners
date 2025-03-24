extends Node2D

@onready var lobby_tabel = $Control/LobbyTabel
@onready var lobbies = $Lobbies #node med alle lobbiesne inde i 


var lockImage #billede af lås til de låste lobbyer
var publicImage


func _ready():
	for lobby in lobbies.get_children():
		pass
	loadTabel()


func _process(delta):
	if  lobby_tabel.item_count != lobbies.get_child_count():
		loadTabel()


func loadTabel():
	lobby_tabel.clear()
	for lobby in lobbies.get_children():
		if lobby.private:
			lobby_tabel.add_item(lobby.name, lockImage)
		else:
			lobby_tabel.add_item(lobby.name, publicImage)


func _on_lobby_tabel_item_clicked(index, at_position, mouse_button_index):
	#send til lobby'en der passer til index'et clicket
	# / opret lobby udfra clicket lobby
	pass
