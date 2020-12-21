extends Node2D

var hp
var max_hp

func _ready():
	pass

func set_both_hp(new_hp,new_max_hp):
	max_hp = new_max_hp
	hp = new_hp
	update_hp()

func change_hp(difference_hp):
	hp+=difference_hp
	check_valid_hp()

func change_max_hp(difference_max_hp):
	max_hp += difference_max_hp
	check_valid_hp()

func check_valid_hp():
	if(hp>max_hp):
		hp=max_hp
	update_hp()

func update_hp():	
	$Player_hp.text = String(hp)+"/"+String(max_hp)
