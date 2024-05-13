extends State


func _unhandled_input(_event:InputEvent):
	if G.check_any_key_and_click(_event):
		fsm.translation_to("MainGame")
