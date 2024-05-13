# queue_redrawで再描画できるようにNode2Dを継承
extends Node2D


@export var score:int = 0:
	set(value):
		score = value
		queue_redraw()


# Called when the node enters the scene tree for the first time.
func _draw():
	var children:Array = %GridContainer.get_children()
	var columns = %GridContainer.columns
	
	var y_size:float = children.size() / columns
	assert(y_size == int(y_size), "子の数がおかしい")
	
	for i in children.size():
		var child = children[i]
		var x:int = i % columns
		var y:int = int(i / columns)
			
		var n:int = y + x * y_size
			
		child.get_node("Sprite").frame = 1 if n < score else 0
