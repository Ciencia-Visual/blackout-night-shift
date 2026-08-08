shader_type canvas_item;

uniform vec4 outline_color : source_color = vec4(1.0, 1.0, 0.0, 1.0);
uniform float outline_size : hint_range(1.0, 10.0) = 2.0;
uniform bool enabled = true;

void vertex() {
	
}

void fragment() {
	vec4 tex = texture(TEXTURE, UV);
	
	if (enabled) {
		vec2 p = TEXTURE_PIXEL_SIZE * outline_size;
		float outline = 0.0;
		
		outline = max(outline, texture(TEXTURE, UV + vec2( p.x, 0.0 )).a);
		outline = max(outline, texture(TEXTURE, UV + vec2( -p.x, 0.0 )).a);
		outline = max(outline, texture(TEXTURE, UV + vec2( 0.0, p.y )).a);
		outline = max(outline, texture(TEXTURE, UV + vec2( 0.0, -p.y )).a);
		
		if (tex.a == 0.0 && outline > 0.0) 
			COLOR = outline_color;
		else
			COLOR = tex;
	} else {
		COLOR = tex;
	}
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
