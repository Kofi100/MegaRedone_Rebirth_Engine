shader_type canvas_item;
uniform vec4 outline_color_original:source_color;
uniform vec4 bodycolororiginal1:source_color;
uniform vec4 bodycolororiginal2:source_color;
uniform vec4 outlinecolor:source_color;uniform vec4 bodycolori:source_color;
uniform vec4 bodycolorii:source_color;
void fragment(){
	vec4 color=texture(TEXTURE,UV);
	
	if (color==outline_color_original){
		COLOR=outlinecolor;
	}
	if (color==bodycolororiginal1){
		COLOR=bodycolori;
	}
	if (color==bodycolororiginal2){
		COLOR=bodycolorii;
	}
}