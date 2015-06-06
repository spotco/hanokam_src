varying float alpha_gradient_x;
varying float alpha_gradient_y;

void main(){
	vec2 texCoord = cc_FragTexCoord1;
	vec4 textureColor = texture2D(cc_MainTexture, texCoord);
	
	gl_FragColor.r = textureColor.r;
	gl_FragColor.g = textureColor.g;
	gl_FragColor.b = textureColor.b;
	gl_FragColor.a = textureColor.a * alpha_gradient_x;

}