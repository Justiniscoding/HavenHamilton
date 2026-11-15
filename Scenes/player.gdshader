shader_type canvas_item;

uniform bool enabled = false;

void fragment() {
	if(enabled == true){
		
	float time = 0.0;

	float dist = sqrt(pow(UV.y - 0.5, 2) + pow(UV.x - 0.5, 2));
	dist = pow(dist, max(TIME * 2.0, 0.0));
	
	if(dist < 0.5){
		float angle = atan(UV.x - 0.5, UV.y - 0.5);
		
		vec2 samplePos = vec2(sin(angle), cos(angle)) * dist + vec2(0.5, 0.5);
		
		vec4 texture = texture(TEXTURE, samplePos);
		
		COLOR = texture;
	}else{
		COLOR = vec4(0, 0, 0, 0);
	}
	}
}