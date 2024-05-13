class_name State
extends Node2D

var msg
var fsm = null


func can_translation() -> bool:
	return true


func exit() -> void:
	pass


func enter(_msg = {}) -> void:
	msg = _msg
