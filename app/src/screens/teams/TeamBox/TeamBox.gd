# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

class_name TeamBox

extends HBoxContainer

signal deleted

@onready var name_label:Label = $Name
@onready var delete_dialog:ConfirmationDialog = $DeleteDialog
@onready var delete_dialog_team_name:Label = $DeleteDialog/Team

var team:Team

func set_up(team:Team) -> void:
	self.team = team
	name_label.text = team.name
	delete_dialog_team_name.text = team.name


func _on_delete_pressed() -> void:
	delete_dialog.popup_centered()

func _on_delete_dialog_confirmed() -> void:
	Config.delete_team(team)
	deleted.emit()

func _on_edit_pressed() -> void:
	pass # Replace with function body.