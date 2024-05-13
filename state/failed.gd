extends State

var t:float


func _ready():
	var player = fsm.owner.get_node("Player")
	player.die()
	
	t = 0.0


func _process(_delta):
	t += _delta
	
	if 1.0 <= t:
		fsm.translation_to("Result")
