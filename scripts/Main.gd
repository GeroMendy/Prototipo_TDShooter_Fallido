extends Node

var Mouse_reloaded = load("res://assets/Mouse1.png")
var Mouse_reloading = load("res://assets/Mouse2.png")

var Player = preload("../scenes/Player.tscn")
var Bullet = preload("../scenes/Bullet.tscn")
var Enemy = preload("../scenes/Enemy.tscn")
var TileMap = preload("../scenes/TileMap.tscn")
var tilemap_size
var screen_size


func _ready():
	randomize()
	screen_size = Vector2(ProjectSettings.get_setting("display/window/size/width"),ProjectSettings.get_setting("display/window/size/height"))
	#generate_map()
	start()
# warning-ignore:return_value_discarded
	$Player/Gun.connect("reloaded",self,"_on_PlayerGun_reloaded")
# warning-ignore:return_value_discarded
	$Player/Gun.connect("reloading",self,"_on_PlayerGun_reloading")

func generate_map():
	var new_tm = TileMap.instance()
	tilemap_size = new_tm.cell_size.x
	var max_value
	var vertical
	var current_wall = Vector2()
	for i in range(4):
		match i:
			0:
				current_wall = Vector2(0,0)
				vertical = true
				max_value = screen_size.y/(tilemap_size*2) + tilemap_size
			1:
				current_wall = Vector2(screen_size.x,0)
				vertical = true
				max_value = screen_size.y/(tilemap_size*2) + tilemap_size
			2:
				current_wall = Vector2(tilemap_size,0)
				vertical = false
				max_value = screen_size.x/(tilemap_size*2) + tilemap_size
			3:
				current_wall = Vector2(tilemap_size,screen_size.y)
				vertical = false
				max_value = screen_size.x/(tilemap_size*2)
		
		for current_tile in max_value:
			new_tm = TileMap.instance()
			if(vertical):
				new_tm.position = Vector2(current_wall.x, current_tile +(max_value * tilemap_size * 2))
			else:
				new_tm.position = Vector2( current_tile +(max_value * tilemap_size * 2),current_wall.y)
			add_child(new_tm)

func start():
	$Player.start($InitialPositionPlayer.position)
	$HUD_single_player.set_both_hp(10,10)
	$HUD_single_player.show()
	$Player.show()
	$BulletTimer.start()
	get_tree().call_group("Bullets","queue_free")
	get_tree().call_group("Enemies","queue_free")
	generate_enemy()

func generate_enemy():
	var enemy = Enemy.instance()
	call_deferred("add_child",enemy)
	enemy.position = $InitialEnemyPosition.position
	enemy.connect("ready_to_shoot", self, "_on_Enemy_ready_to_shoot")
	enemy.connect("dead", self, "_on_Enemy_dead")

func _on_Player_death():
	
	$Player.set_position($DeathPositionPlayer.position)
	var label = Label.new()
	label.text = "You died"
	label.rect_position = $DeathLabelPosition.position
	label.rect_scale = Vector2(2,2)
	add_child(label)
	$HUD_single_player.hide()
	$Player.hide()
	yield(get_tree().create_timer(3), "timeout")
	label.queue_free()
	$BulletTimer.stop()
	
	start()


func _on_Player_hp_changed(damage):
	$HUD_single_player.change_hp(-damage)
	#El valor debería llegar desde el objeto que 'haga el daño'


func _on_BulletTimer_timeout():
	var bullet = Bullet.instance()
	add_child(bullet)
	var type = rand_range(0,4)
	type = int(type)
	if type==0:
		bullet.set_is_enemy(false)
	else:
		bullet.set_is_enemy(true)
	bullet.set_color(type)
	bullet.set_damage(type)
	#/DEBUG:
	bullet.set_is_enemy(true)
	#DEBUG/
	var algo = rand_range(0,2)
	algo = int (algo)
	var dir
	var pos
	if(algo==1):
		dir = PI
		pos = $InitialPositionBullet.position
	else:
		dir = 0
		pos = $SecondInitialPositionBullet.position
	bullet.position = pos
	bullet.rotation = dir
	bullet.linear_velocity = Vector2(bullet.speed,0)
	bullet.linear_velocity = bullet.linear_velocity.rotated(dir)


func _on_Player_body_entered(body) ->void:
	print_debug("_on_Player_body_entered")
	var bul := body as Bullet
	if not bul:
		return
	if (!bul.is_enemy):
		return
	$Player.lose_hp(bul.damage)
	bul.destroy_self()

func _on_Enemy_ready_to_shoot(enemy):
	var e := enemy as Enemy
	e.shoot($Player.position)

func _on_Enemy_dead(enemy):
	print_debug("enemy_dead")
	var e := enemy as Enemy
	e.queue_free()

func _on_PlayerGun_reloaded():
	Input.set_custom_mouse_cursor(Mouse_reloaded)

func _on_PlayerGun_reloading():
	Input.set_custom_mouse_cursor(Mouse_reloading)
