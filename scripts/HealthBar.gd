extends Node2D

var max_hp = 10
var current_hp = 10

func _ready():
	pass # Replace with function body.


func set_max_hp(new_max_hp):
	max_hp = new_max_hp
	update_health_bar()

func set_current_ho(new_current_hp):
	current_hp = new_current_hp
	update_health_bar()

func update_health_bar(new_max_hp = max_hp, new_current_hp = current_hp):
	if(new_max_hp<new_current_hp):
		new_current_hp = new_max_hp
	current_hp = new_current_hp
	max_hp = new_max_hp
	var difference = ($Max_hp.rect_size.x / max_hp) * current_hp
	$Current_hp.rect_size.x = difference
