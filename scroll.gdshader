shader_type canvas_item;

uniform float speed = 1.5;

void vertex() {
	UV.x += TIME * speed;
}
