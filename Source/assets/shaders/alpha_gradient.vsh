varying float alpha_gradient_x;
varying float alpha_gradient_y;

uniform float start_x;
uniform float start_y;
uniform float start_alpha_x;
uniform float end_alpha_x;
uniform float start_alpha_y;
uniform float end_alpha_y;
uniform float width;
uniform float height;

void main(){
	gl_Position = cc_Position;
	cc_FragTexCoord1 = cc_TexCoord1;
	cc_FragColor = clamp(cc_Color, 0.0, 1.0);
	alpha_gradient_x = mix(start_alpha_x,end_alpha_x,(cc_Position.x-start_x)/width);
	alpha_gradient_y = mix(start_alpha_y,end_alpha_y,(cc_Position.y-start_y)/height);
}