# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.com>

# SPDX-License-Identifier: AGPL-3.0-or-later

extends Control

@onready var table:GridContainer = $ScrollContainer/GridContainer

var list_path:String = "res://assets/players/players_05082023.csv"



func _ready() -> void:
	if Config.players.is_empty():
		for pos in Config.POSITIONS:
			Config.players[pos] = []
			
		var file:FileAccess = FileAccess.open(list_path, FileAccess.READ)
		_init_players(file)
	
	for pos in Config.POSITIONS:
		for player in Config.players[pos]:
			var label:Label = Label.new()
			label.text = player_to_string(player)
			table.add_child(label)

func current_player() -> Dictionary:
	return Config.players[Config.POSITIONS[Config.active_position]][Config.active_player]

func next_player() -> Dictionary:
	if Config.active_player + 1 < Config.players[Config.POSITIONS[Config.active_position]].size():
		Config.active_player += 1
		return current_player()
	elif Config.active_position + 1  < Config.POSITIONS.size():
		Config.active_position += 1
		Config.active_player = 0
		return current_player() 
	return {}

func _on_file_dialog_file_selected(path: String) -> void:
	list_path = path


func _on_file_dialog_confirmed() -> void:
	var file:FileAccess = FileAccess.open(list_path, FileAccess.READ)
	_init_players(file)
	
func _init_players(file:FileAccess):
	# skip header lines
	while not file.eof_reached():
		var line:Array = file.get_csv_line()
		if line[0] == "Id":
			break
	
	while not file.eof_reached():
		var line:Array = file.get_csv_line()
		# check if not empty
		if not line[0]:
			break
		var pos = line[1]
		Config.players[pos].append(_get_player(line))
	
	for pos in Config.POSITIONS:
		Config.players[pos].sort_custom(func(a, b): return a.name < b.name)
		
func _get_player(line:Array) -> Dictionary:
	return {
		"id" : line[0],
		"position" : line[1],
		"name" : line[2],
		"team" : line[3],
		"mfv" : line[4],
		"price_initial" : line[5],
		"price_current" : line[6],
		"price" : 0,
	}
	
func player_to_string(player:Dictionary) -> String:
	return "%s %s %s %s"%[player["position"],player["team"],player["price_initial"],player["name"]]
	

	
func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://src/menu/Menu.tscn")