extends Area2D

export (PackedScene) var Bullet

var damage = 1
var extra_damage = 0
var damage_multiplier = 1
var actual_damage = (damage+extra_damage)*damage_multiplier

var bullet_speed = 400
var extra_bullet_speed = 0
var bullet_speed_multiplier = 1
var actual_bullet_speed = (bullet_speed+extra_bullet_speed)*bullet_speed_multiplier

var reload_time = 0.50
var extra_reload_time = 0
var reload_time_multiplier = 1
var actual_reload_time = (reload_time+extra_reload_time)*reload_time_multiplier

var is_reloading = false
var is_ally = false
var is_enemy = false

signal reloading
signal reloaded

func aim_to(dir):
	rotation = dir;

func shoot(pos,dir):
	if(is_reloading):
		return
	var bullet = Bullet.instance()
	bullet.set_basic_info(actual_damage,is_ally,is_enemy,actual_bullet_speed)
	
	var root = get_tree().get_root()
	root.call_deferred("add_child", bullet)
	
	bullet.position = (pos + position)
	bullet.rotation = dir
	bullet.linear_velocity = Vector2(bullet.speed,0)
	bullet.linear_velocity = bullet.linear_velocity.rotated(dir)
	reload()

func reload():
	is_reloading = true
	$ReloadingTimer.start()
	$ColorRect.color = Color(0.5,0.5,0.5,1)
	emit_signal("reloading")







#Sets/Gets:
func set_basic_info(new_damage = 1, new_is_ally = false, new_is_enemy = false, new_bullet_speed = 200, new_reload_time = 0.50):
	damage = new_damage
	is_ally = new_is_ally
	is_enemy = new_is_enemy
	bullet_speed = new_bullet_speed
	reload_time = new_reload_time

func set_damage(new_damage):
	damage = new_damage
	update_actual_damage()
func set_extra_damage(new_extra_damage):
	extra_damage = new_extra_damage
	update_actual_damage()
func set_damage_multiplier(new_damage_multiplier):
	damage_multiplier = new_damage_multiplier
	update_actual_damage()

func update_actual_damage():
	actual_damage = (damage+extra_damage)*damage_multiplier

func set_bullet_speed(new_bullet_speed):
	bullet_speed = new_bullet_speed
	update_actual_bullet_speed()
func set_extra_bullet_speed(new_extra_bullet_speed):
	extra_bullet_speed = new_extra_bullet_speed
	update_actual_bullet_speed()
func set_bullet_speed_multiplier(new_bullet_speed_multiplier):
	bullet_speed_multiplier = new_bullet_speed_multiplier
	update_actual_bullet_speed()

func update_actual_bullet_speed():
	actual_bullet_speed = (bullet_speed+extra_bullet_speed)*bullet_speed_multiplier

func set_reload_time(new_reload_time):
	reload_time = new_reload_time
	update_actual_reload_time()
func set_extra_reload_time(new_extra_reload_time):
	extra_reload_time = new_extra_reload_time
	update_actual_reload_time()
func set_reload_time_multiplier(new_reload_time_multiplier):
	reload_time_multiplier = new_reload_time_multiplier
	update_actual_reload_time()

func update_actual_reload_time():
	actual_reload_time = (reload_time+extra_reload_time)*reload_time_multiplier
	$ReloadingTimer.wait_time = actual_reload_time

func set_is_ally(new_is_ally = false):
	is_ally = new_is_ally

func set_is_enemy(new_is_enemy = false):
	is_enemy = new_is_enemy
#/Sets/Gets


func _on_ReloadingTimer_timeout():
	is_reloading = false
	$ColorRect.color = Color(0,0,0,1)
	emit_signal("reloaded")
