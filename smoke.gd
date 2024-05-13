@tool
extends Sprite2D

# DebugCameraはsmoke.tscnを単体実行時(F6 Key)に、
# 画面中央に描画するためのもの

@export_range(0, 1) var init_frame:int = 0:
	set(value):
		init_frame = value
		self.frame = value


func _ready():
	self.frame = init_frame


func _on_timer_timeout():
	frame = (frame + 1) % 2 # next frame
