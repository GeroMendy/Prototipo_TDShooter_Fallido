extends KinematicBody2D

class_name Player

export var speed = 400
var screen_size
var is_damageable
var invisible_time

signal hit
signal death
signal hp_changed(damage)

const BASIC_MAX_HP = 10
var current_max_hp
var hp

func _ready():
	screen_size = get_viewport_rect().size
	is_damageable = false
	invisible_time = 0.5
	hide()

func _input(event):
	if(event is InputEventMouseButton):
		if(get_current_hp()>0):
			var dir = PI+((position+$Gun.position)-get_viewport().get_mouse_position()).angle()
			$Gun.shoot(position,dir)

func _process(delta):
	var velocity = Vector2()
	if Input.is_action_pressed("ui_right"):
		velocity.x += 1
	if Input.is_action_pressed("ui_left"):
		velocity.x -= 1
	if Input.is_action_pressed("ui_up"):
		velocity.y -= 1
	if Input.is_action_pressed("ui_down"):
		velocity.y += 1
	if velocity.length()>0:
		velocity = velocity.normalized() * speed
#		$AnimatedSprite.play()
#	else:
#		$AnimatedSprite.stop()
	
	position += velocity * delta
	position.x = clamp(position.x, 0, screen_size.x)
	position.y = clamp(position.y, 0, screen_size.y)
#
#	if velocity.x != 0:
#		$AnimatedSprite.animation = "walk"
#		$AnimatedSprite.flip_v = false
#		$AnimatedSprite.flip_h = velocity.x < 0
#	elif velocity.y != 0:
#		$AnimatedSprite.animation = "up"
#		$AnimatedSprite.flip_v = velocity.y > 0
	if($Gun):
		$Gun.aim_to(PI+((position+$Gun.position)-get_viewport().get_mouse_position()).angle())

# warning-ignore:unused_argument
func _on_Player_body_entered(body):
#	hide()
	emit_signal("hit")
#	$CollisionShape2D.set_deferred("disabled", true)

func start(pos):
	is_damageable = true
	position = pos
	show()
	current_max_hp = BASIC_MAX_HP
	hp = current_max_hp
	$Gun.set_is_ally(true)
	$Gun.set_is_enemy(false)

func lose_hp(damage):
	if(is_damageable):
		hp -=damage
		if(hp<=0):
			emit_signal("death")
			is_damageable = false
		else:
			make_player_temporarily_undamageable(invisible_time)
			emit_signal("hp_changed",damage)
#			sound_play_player_damaged()

func make_player_temporarily_undamageable(time):
	is_damageable = false
	time = time/10
	for i in 5:
		hide()
		yield(get_tree().create_timer(time), "timeout")
		show()
		yield(get_tree().create_timer(time), "timeout")
	is_damageable = true
	
func get_current_hp():
	return hp

func get_current_max_hp():
	return current_max_hp

func set_position(pos):
	position = pos
