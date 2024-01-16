shader_type canvas_item;

void fragment() {
	// Place fragment code here.
	COLOR*= vec4(1.0+sin(TIME*10.0)*0.1);
}
