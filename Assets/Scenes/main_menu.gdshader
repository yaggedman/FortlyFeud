shader_type canvas_item;

uniform float scroll_speed;
void fragment(){
    vec2 shifteduv = UV;
    shifteduv .x += TIME * scroll_speed;
    vec4 color = texture(TEXTURE, shifteduv);
    COLOR = color;


}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
