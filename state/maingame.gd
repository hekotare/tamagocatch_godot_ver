extends State


var game_time:float
var event_list:Array
var is_failed:bool


func _ready():
	var score = fsm.owner.get_node("Score")
	score.score = 0
	
	game_time = 0 # Replace with function body.
	event_list = G.create_event_list()
	is_failed = false
	
	var player = fsm.owner.get_node("Player")
	player.reset()
	
	$AudioStreamPlayer.play()
	
	for proj:Projectile in %ProjectileList.get_children():
		%ProjectileList.remove_child(proj)


func _process(_delta):
	game_time += _delta
	
	# 卵とボムを発生させる
	event_proc()
	
	if event_list.size() == 0 and %ProjectileList.get_children().size() == 0:
		fsm.translation_to("Result")
		return
	
	# update projectile
	for proj:Projectile in %ProjectileList.get_children():
		update_proj(proj)
	
	if is_failed:
		fsm.translation_to("Failed")


func event_proc():

	var frame:int = int(game_time * 60.0)
	
	while event_list.size() != 0:
		var e:G.Event = event_list[0]
		
		if e.trigger_frame <= frame:
			event_list.pop_front()
			# 発射
			happen_proj(e.projectile_type, e.move_type)
			
			var pitcher = fsm.owner.get_node("Pitcher")
			pitcher.throwing()
		else: # イベントなし
			break


func happen_proj(proj_type, move_type):
	
	var fllow:PathFollow2D
	if move_type == G.MoveType.NORMAL:
		fllow = $Path/PathFollow
	else: # yamanari
		fllow = $Path2/PathFollow2
	
	var proj:Projectile = Projectile.create(proj_type)
	proj.initialize(game_time, fllow)
	%ProjectileList.add_child(proj)
	
	print("弾の発生")


func update_proj(proj):

	var player = fsm.owner.get_node("Player")
	var score = fsm.owner.get_node("Score")
	
	if proj.is_finished:
		
		if proj.fllow == %OutPathFollow:
			proj.queue_free()
		else:
			# プレイヤーに向かっている弾を
			# ガード、ダメージ、スコア加算のどれかで処理する
			if player.is_guard():
				player.guard()
				
				var new_proj:Projectile = Projectile.create(proj.proj_type)
				new_proj.initialize(game_time, %OutPathFollow)
				%ProjectileList.add_child(new_proj)
				
				proj.queue_free()
			else:
				if proj.proj_type == G.ProjectileType.EGG:
					player.eat()
					score.score += 1
					proj.queue_free()
				
				elif proj.proj_type == G.ProjectileType.BOMB:
					if proj.bomb_counter <= 0: # 1フレームのミスはなかったことにする
						is_failed = true
						proj.queue_free()
					else:
						proj.bomb_counter -= 1
	else:
		proj.update_position(game_time)
