extends Area2D

class_name Enemy

var Player = preload("../scenes/Player.tscn")
var Bullet = preload("../scenes/Bullet.tscn")

#DEBUG:
var screen_size
#/DEBUG

var speed = 80
var direccion = Vector2()
var space_movement=8
var shot_rate = 0.8
var vision = 22#50
var min_move_time = 3
var max_move_time = 5
var min_space_movement = 5*speed
var max_space_movement = 20*speed
var reloaded = true
var watching_enemy = false
var rng

var friendly_fire = false

const BASIC_MAX_HP = 3
var current_max_hp
var hp

signal ready_to_shoot(enemy)
signal dead(enemy)
#signal lost_hp(enemy)

func _ready():
	rng = RandomNumberGenerator.new()
	start()
	update_gun_data()
	#DEBUG:
	screen_size = get_viewport_rect().size
	#/DEBUG

func start():
	current_max_hp = BASIC_MAX_HP
	hp = current_max_hp
	space_movement = 0
	update_reload_timer()
	$VisionCircle.scale.x = 0
	$VisionCircle.scale.y = 0
	update_vision()
	$Starting_Timer.start()

func update_gun_data():
	$Gun.set_reload_time(shot_rate)
	$Gun.set_is_enemy(true)
	$Gun.set_is_ally(friendly_fire)

func update_reload_timer():
	update_gun_data()

func update_vision():
	$VisionCircle.scale.x = vision
	$VisionCircle.scale.y = vision

func _process(delta):
	if(space_movement>0): 
		direccion = direccion.normalized() * speed
		position += direccion * delta
		space_movement = space_movement-1
	position.x = clamp(position.x, 0, screen_size.x)
	position.y = clamp(position.y, 0, screen_size.y)

func try_shoot():
	if(reloaded && watching_enemy):
		emit_signal("ready_to_shoot",self)

func shoot(enemy_position):
	var angle = PI+ ((position+$Gun.position)-enemy_position).angle()
	$Gun.rotation = angle
	$Gun.shoot(position,angle)

func lose_hp(damage):
	hp-=damage
	if(hp<=0):
		emit_signal("dead",self)
	else:
		check_hp_integrity()
		display_hit_animation()
	
	space_movement = 0
	$Move_Timer.stop()
	_on_Move_Timer_timeout()


func display_hit_animation():
	var real_color = $ColorRect.color
	var gun_real_color = $Gun/ColorRect.color
	$ColorRect.color = Color(1,1,1,1)
	$Gun/ColorRect.color = Color(1,1,1,1)
	yield(get_tree().create_timer(0.1), "timeout")
	$ColorRect.color = real_color
	$Gun/ColorRect.color = gun_real_color

func check_hp_integrity():
	if(hp>current_max_hp):
		hp = current_max_hp
	$HealthBar.update_health_bar(current_max_hp,hp)

#Sets/Gets
func set_speed(new_speed=speed):
	speed = new_speed

func add_speed(difference_speed=0):
	speed += difference_speed

func multiply_speed(multiplier=1):
	speed *= multiplier

func set_direccion(new_direccion):
	direccion = new_direccion

func set_shot_rate(new_shot_rate = shot_rate):
	shot_rate = new_shot_rate
	update_reload_timer()

func add_shot_rate(difference=0):
	shot_rate += difference
	update_reload_timer()

func multiply_shot_rate(multiply=1):
	shot_rate*=multiply
	update_reload_timer()

func set_vision(new_vision=vision):
	vision = new_vision
	update_vision()

func add_vision(difference=0):
	vision += difference
	update_vision()

func multiply_vision(multiplier=1):
	vision *= multiplier
	update_vision()












#Timers_timeout
func _on_Starting_Timer_timeout():
	$Move_Timer.start()


func _on_Move_Timer_timeout():
	rng.randomize()
	
	var new_time = rng.randf_range(min_move_time,max_move_time)
	var new_dir_x = rng.randf_range(-1 , 1)
	var new_dir_y = rng.randf_range(-1 , 1)
	var new_spc_move = rng.randf_range(min_space_movement,max_space_movement)
	$Move_Timer.wait_time = new_time
	$Move_Timer.start()
	direccion.x = new_dir_x
	direccion.y = new_dir_y
	space_movement = new_spc_move
	if (!watching_enemy):
		var gun_direction = Vector2()
		gun_direction.x = direccion.x
		gun_direction.y = direccion.y * 0.1
		$Gun.rotation = gun_direction.angle()


#Signals

func _on_VisionCircle_area_entered(area):
	var p1 := area as Player
	if not p1:
		return
	watching_enemy = true
	try_shoot()


func _on_Gun_reloaded():
	reloaded = true
	try_shoot()


func _on_VisionCircle_area_exited(area):
	var p1 := area as Player
	if not p1:
		return
	watching_enemy = false


func _on_Enemy_body_entered(body):
	var bul := body as Bullet
	if not bul:
		return
	if (!bul.is_ally):
		return
	lose_hp(bul.damage)
	bul.destroy_self()
