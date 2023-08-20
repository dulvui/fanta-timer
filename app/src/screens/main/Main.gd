# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.com>

# SPDX-License-Identifier: AGPL-3.0-or-later

extends Control

const AuctionTimer:PackedScene = preload("res://src/ui-components/timer/Timer.tscn")

@onready var player_label:Label = $MarginContainer/HSplitContainer/VBoxContainer/ActivePlayer
@onready var assign_player:PopupPanel = $AssignPlayer
@onready var team_overview:Control = $MarginContainer/HSplitContainer/VBoxContainer/TeamOverview
@onready var player_list:Control = $MarginContainer/HSplitContainer/VSplitContainer/PlayerList
@onready var history:Control = $MarginContainer/HSplitContainer/VSplitContainer/History

var active_player:Player

func _ready() -> void:
	active_player = Config.active_player()
	player_label.text = active_player.name


func _on_auction_pressed() -> void:
	var timer = AuctionTimer.instantiate()
	timer.set_player(active_player)
	add_child(timer)


func _on_assign_pressed() -> void:
	assign_player.set_player(active_player)
	assign_player.popup_centered()

func _on_assign_player_assigned() -> void:
	_refresh_lists()
	active_player = Config.active_player()
	player_label.text = active_player.name


func _on_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://src/screens/menu/Menu.tscn")


func _on_next_pressed() -> void:
	active_player = Config.next_player()
	player_label.text = active_player.name
	player_list.set_up_list()


func _on_previous_pressed() -> void:
	active_player = Config.previous_player()
	player_label.text = active_player.name
	player_list.set_up_list()


func _on_team_overview_player_removed(player:Player, team:Team) -> void:
	Config.remove_player_from_team(player, team)
	_refresh_lists()
	
func _refresh_lists() -> void:
	team_overview.set_up()
	player_list.set_up_list()
	history.set_up()
