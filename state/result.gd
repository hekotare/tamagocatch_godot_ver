extends State


func _ready():

	if G.is_debug_current_scene(self):
		_debug_ready()
		return
	
	$AudioStreamPlayer.play()
	
	var score:Node = fsm.owner.get_node("Score")
	
	var anim_player:AnimationPlayer = %Label/AnimationPlayer
	
	%Label.text = str(score.score) + " / 30"
	
	anim_player.play("RESET")
	if score.score == 30:
		anim_player.play("gold")
	elif score.score >= 20:
		anim_player.play("flash")
	
	await $AudioStreamPlayer.finished
	
	fsm.translation_to("StartMenu")


func _debug_ready():
	var MAIN:PackedScene = load("res://main.tscn")
	var scene:Main = MAIN.instantiate()
	var fsm:StateMachine = scene.get_node("FSM")
	fsm.initial_state = "Result"
	
	# スコアの書き換え
	scene.get_node("Score").score = 30
	
	get_tree().root.call_deferred("add_child", scene) 
	#get_tree().root.add_child(scene)
	queue_free()
