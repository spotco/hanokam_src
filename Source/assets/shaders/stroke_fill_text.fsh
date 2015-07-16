uniform vec4 fill_color;
uniform vec4 stroke_color;

void main(){
	vec2 texCoord = cc_FragTexCoord1;
	vec4 textureColor = texture2D(cc_MainTexture, texCoord);
	
	gl_FragColor = textureColor.r * stroke_color + textureColor.b * fill_color;
}