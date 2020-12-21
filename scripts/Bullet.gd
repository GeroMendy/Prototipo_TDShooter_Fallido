extends RigidBody2D
class_name Bullet

var damage
var is_ally
var is_enemy
var speed

func _init():
	damage  = 1
	is_ally = false
	is_enemy = false
	speed = 200

func set_basic_info(new_damage = 1,new_is_ally = false, new_is_enemy = false, new_speed= 200):
	damage = new_damage
	is_ally = new_is_ally
	is_enemy = new_is_enemy
	speed = new_speed


func set_damage(new_damage=damage):
	damage = new_damage

func add_extra_damage(difference_damage=0):
	damage += difference_damage

func multiply_damage(damage_multiplier=1):
	damage *= damage_multiplier


func set_speed(new_speed=speed):
	speed = new_speed

func add_extra_speed(difference_speed=0):
	speed += difference_speed

func multiply_speed(speed_multiplier=1):
	speed *= speed_multiplier

func set_is_ally(new_is_ally = false):
	is_ally = new_is_ally

func set_is_enemy(new_is_enemy=false):
	is_enemy = new_is_enemy

#DEBUG/
func set_color(color=0):
	match color:
		0:
			$ColorRect.color = Color(0.67,0.7,0.1,1)
		1:
			$ColorRect.color = Color(0,0.7,0.1,1)
		2:
			$ColorRect.color = Color(0.67,0,0.1,1)
		3:
			$ColorRect.color = Color(0.67,0.7,1,1)
#/DEBUG

# warning-ignore:unused_argument
func destroy_self(hitted_character=false):
	#Creo una nueva funcion para agregar animacion, sonido, etc.
	queue_free()

#DEBUG/
func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
#/DEBUG
