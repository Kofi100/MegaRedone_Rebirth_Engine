shader_type canvas_item;
uniform vec4 original_color1:source_color;
uniform vec4 new_color1:source_color;
uniform vec4 original_color2:source_color;
uniform vec4 new_color2:source_color;
void fragment() {
//pass
	vec4 color=texture(TEXTURE,UV);
	if (color==original_color1){
		COLOR=new_color1;
	}
	else if (color==original_color2){
		COLOR=new_color2;
	}
}