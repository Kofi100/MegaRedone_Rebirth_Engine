shader_type canvas_item;
uniform vec4 whitecolor:source_color;
uniform vec4 greycolor:source_color;
uniform vec4 whiterep:source_color;
uniform vec4 greyrep:source_color;
void fragment() {
	// Place fragment code here.
	vec4 color=texture(TEXTURE,UV);
	if (color==whitecolor){
		COLOR=whiterep;
	}
	else if (color==greycolor){
		COLOR=greyrep;
	}
		
	
}
