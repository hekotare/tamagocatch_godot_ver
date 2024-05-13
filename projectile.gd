class_name Projectile extends Node2D


const BOMB:PackedScene = preload("res://bomb.tscn")
const TAMAGO:PackedScene = preload("res://tamago.tscn")

var start_time:float = 0.0
var is_finished:bool = false
var proj_type:G.ProjectileType
var fllow:PathFollow2D
var start_degree:float
var end_degree:float
var bomb_counter:int = 5 # 失敗猶予フレーム

static func create(type:G.ProjectileType) -> Projectile:
	var proj:Projectile
	
	if type == G.ProjectileType.BOMB:
		proj = BOMB.instantiate()
		proj.proj_type = G.ProjectileType.BOMB
	elif type == G.ProjectileType.EGG:
		proj = TAMAGO.instantiate()
		proj.proj_type = G.ProjectileType.EGG
		proj.start_degree = randf_range(-45, 45)
		proj.end_degree = proj.start_degree + randf_range(-90, 90)
	else:
		assert(false, "unknown_type %=" + str(type))
	
	return proj


func initialize(_start_time:float, _fllow:PathFollow2D):
	start_time = _start_time
	fllow = _fllow
	update_position(_start_time)


func update_position(game_time:float):
	const end_time:float = 1.0
	
	var time_left:float = (game_time - start_time)
	var progress:float = clamp(time_left / end_time, 0.0, 1.0)
	
	if progress == 1.0: is_finished = true
	
	fllow.progress_ratio = progress
	global_position = fllow.global_position
	
	global_rotation_degrees = lerp(start_degree, end_degree, progress)
