shader_type canvas_item;
uniform vec4 originalbodycolor:source_color;
uniform vec4 originalbodycolorii:source_color;
uniform vec4 originaloutlinecolor:source_color;
uniform vec4 bodycolori:source_color;
uniform vec4 bodycolorii:source_color;
uniform vec4 outlinecolor:source_color;
void fragment() {
	// Place fragment code here.
	vec4 color =texture(TEXTURE,UV);
	if (color==originalbodycolor){
		COLOR=bodycolori;
	}
	else if (color==originalbodycolorii){
		COLOR=bodycolorii;
	}
	else if (color==originaloutlinecolor){
		COLOR=outlinecolor;
	}
}
