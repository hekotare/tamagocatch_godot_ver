extends Node2D


#
enum States{
	Eat,
	Guard,
	Die,
}

var state:States = States.Eat


func _process(_delta):
	update_stat()
	queue_redraw() # めんどいので常に再描画


func _draw():
	var f:int = 2
	
	if state == States.Eat:
		f = 0
	elif state == States.Guard:
		f = 1
	elif state == States.Die:
		f = 2
	
	%Sprite.frame = f


func reset():
	state = States.Eat


func die():
	state = States.Die
	$AnimationPlayer.play("die")


func eat():
	$AnimationPlayer.seek(0)
	$AnimationPlayer.play("eat")


func guard():
	$AnimationPlayer.seek(0)
	$AnimationPlayer.play("guard")


func is_eat() -> bool:
	return state == States.Eat


func is_guard() -> bool:
	return state == States.Guard


func update_stat():
	if state == States.Die:
		return
	
	if Input.is_action_pressed("down"):
		state = States.Guard
	else:
		state = States.Eat


func _on_particle_child_entered_tree(node):
	print("node %=", node.name)
