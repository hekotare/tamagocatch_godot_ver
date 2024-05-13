extends Node2D


func throwing():
	$AnimationPlayer.seek(0.0)
	$AnimationPlayer.play("throw")

