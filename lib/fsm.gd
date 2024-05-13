extends Node
class_name StateMachine

# とりあえずの実装
# 
# _ready, _processなどの通知を利用しているので
# なんらかのタイミングの問題とか発生するかも

signal translated(state_name)

@export var initial_state = NodePath()

var state:State
var state_map:Dictionary = {}


# ステートクラス（子ノード）の_readyが呼ばれる前に、親子関係を解除しとく
func _enter_tree():

	# ステートを収集し、階層から外す
	for s in get_children(): # Replace with function body.
		s.fsm = self
		remove_child(s)
		
		state_map[s.name] = s
	
	translation_to(initial_state)


func try_translation(next_state_name:String, msg = {}) -> bool:
	if not has_node(next_state_name):
		push_error("unknown state. next_state_name=" + next_state_name)
		return false
	
	var s = get_node(next_state_name)
	if not s.can_translation():
		return false
	
	translation_to(next_state_name, msg)
	
	return true


func translation_to(next_state_name:String, msg = {}) -> void:
	if next_state_name not in state_map:
		push_error("unknown state. next_state_name=" + next_state_name)
		return
	
	if state != null:
		state.exit()
		remove_child(state)
	
	state = state_map[next_state_name]
	
	state.enter(msg)
	state.request_ready() # 接続毎に_readyを呼び出したい
	add_child(state)
	
	translated.emit(next_state_name)
