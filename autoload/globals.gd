extends Node

enum MoveType {
	NORMAL,
	YAMANARI,
}

enum ProjectileType {
	EGG,
	BOMB,
}

# event_data_listのフレーム数をスケーリングする
const FRAME_SCALE:float = 1.2

# 発射イベント
const event_data_list:Array = \
[
	# 時刻（フレーム）, 種類（卵, 爆弾）, 軌道
	# 値がNone, 0などの場合は、デフォルト値がセットされる
	[10],
	[10, null, G.MoveType.YAMANARI],
	[ 5],
	[10, G.ProjectileType.BOMB],
	[10],
	[10],
	[20],
	[20],
	[20, G.ProjectileType.BOMB],
	[10],
	[30],
	[10, G.ProjectileType.BOMB],
	[10],
	[10],
	[10],
	[10, null, G.MoveType.YAMANARI],
	[16, G.ProjectileType.BOMB],
	[10, G.ProjectileType.BOMB],
	[10],
	[10],
	[10, G.ProjectileType.BOMB],
	[10],
	[10],
	[10],
	[ 5],
	[10, G.ProjectileType.BOMB],
	[ 5],
	[ 5],
	[20],
	[10],
	[5, G.ProjectileType.BOMB, G.MoveType.YAMANARI],
	[6],
	[10],
	[10, G.ProjectileType.BOMB],
	[14],
	[30],
	[ 6, G.ProjectileType.BOMB],
	[10],
	[10],
	[20],
]

class Event:
	var trigger_frame
	var projectile_type:ProjectileType
	var move_type:MoveType


func create_event_list() -> Array:

	var list:Array = []
	var prev_event_frame:int = 0
	
	for event_data:Array in G.event_data_list:
	
		var d:Array = event_data.duplicate()
		
		var e:Event = Event.new()
		
		var frame:int = d.pop_front() * FRAME_SCALE
		e.projectile_type = d.pop_front() or ProjectileType.EGG
		e.move_type = d.pop_front() or MoveType.NORMAL
		e.trigger_frame = prev_event_frame + frame
		
		prev_event_frame = e.trigger_frame
		
		list.append(e)
	
	return list


func check_any_key_and_click(e:InputEvent) -> bool:
	if e is InputEventKey and e.pressed:
		return true
	if e is InputEventMouseButton:
		if e.button_index == MOUSE_BUTTON_LEFT and e.pressed:
			return true
		if e.button_index == MOUSE_BUTTON_RIGHT and e.pressed:
			pass
	
	return false


func is_debug_current_scene(scene):
	return get_tree().current_scene == scene
