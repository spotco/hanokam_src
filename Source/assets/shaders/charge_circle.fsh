uniform float overallAlpha;
void main(){
	vec2 texCoord = cc_FragTexCoord1;
	vec4 textureColor = texture2D(cc_MainTexture, texCoord);
	
	gl_FragColor.r = 1.0;
	gl_FragColor.g = 1.0;
	gl_FragColor.b = 1.0;
	gl_FragColor.a = textureColor.a * cc_FragColor.a * overallAlpha;
}