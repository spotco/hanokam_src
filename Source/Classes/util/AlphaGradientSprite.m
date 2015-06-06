#import "AlphaGradientSprite.h" 
#import "Resource.h"
#import "FileCache.h"

@implementation AlphaGradientSprite {
	CCVertex *_vtx;
}

+(AlphaGradientSprite*)cons_tex:(CCTexture*)tex texrect:(CGRect)texrect size:(CGSize)size anchorPoint:(CGPoint)anchorpt alphaX:(CGRange)alphaX alphaY:(CGRange)alphaY {
	return [[AlphaGradientSprite node] cons_tex:tex texrect:texrect size:size anchorPoint:anchorpt alphaX:alphaX alphaY:alphaY];
}

-(AlphaGradientSprite*)cons_tex:(CCTexture*)tex texrect:(CGRect)texrect size:(CGSize)size anchorPoint:(CGPoint)anchorpt alphaX:(CGRange)alphaX alphaY:(CGRange)alphaY {
	_vtx = calloc(sizeof(CCVertex), 4);
	[self setTexture:tex];
	
	//0,0
	_vtx[0].position = GLKVector4Make(-size.width*anchorpt.x, -size.height*anchorpt.y, 0, 1);
	_vtx[0].texCoord1 = GLKVector2Make(texrect.origin.x/tex.pixelWidth, texrect.origin.y/tex.pixelHeight);
	_vtx[0].color = GLKVector4Make(1, 1, 1, alphaX.min * alphaY.min);
	
	//0,1
	_vtx[1].position = GLKVector4Make(-size.width*anchorpt.x, size.height*(1-anchorpt.y), 0, 1);
	_vtx[1].texCoord1 = GLKVector2Make(texrect.origin.x/tex.pixelWidth, (texrect.origin.y + texrect.size.height)/tex.pixelHeight);
	_vtx[1].color = GLKVector4Make(1, 1, 1, alphaX.min * alphaY.max);
	
	//1,1
	_vtx[2].position = GLKVector4Make(size.width*(1-anchorpt.x), size.height*(1-anchorpt.y), 0, 1);
	_vtx[2].texCoord1 = GLKVector2Make((texrect.origin.x + texrect.size.width)/tex.pixelWidth, (texrect.origin.y + texrect.size.height)/tex.pixelHeight);
	_vtx[2].color = GLKVector4Make(1, 1, 1, alphaX.max * alphaY.max);
	
	//1,0
	_vtx[3].position = GLKVector4Make(size.width*(1-anchorpt.x), -size.height*anchorpt.y, 0, 1);
	_vtx[3].texCoord1 = GLKVector2Make((texrect.origin.x + texrect.size.width)/tex.pixelWidth, texrect.origin.y/tex.pixelHeight);
	_vtx[3].color = GLKVector4Make(1, 1, 1, alphaX.max * alphaY.min);
	
	[self setBlendMode:[CCBlendMode alphaMode]];
	
	return self;
}

-(void)dealloc {
	free(_vtx);
}

CCVertex CCVertexMultiplyAlpha(CCVertex input, float alpha) {
	input.color.w *= alpha;
	return input;
}

-(void)draw:(CCRenderer *)renderer transform:(const GLKMatrix4 *)transform {
	CCRenderBuffer buffer = [renderer enqueueTriangles:2 andVertexes:4 withState:self.renderState globalSortOrder:0];
	
	CCRenderBufferSetVertex(buffer, 0, CCVertexApplyTransform(CCVertexMultiplyAlpha(_vtx[0],self.opacity),transform));
	CCRenderBufferSetVertex(buffer, 1, CCVertexApplyTransform(CCVertexMultiplyAlpha(_vtx[1],self.opacity),transform));
	CCRenderBufferSetVertex(buffer, 2, CCVertexApplyTransform(CCVertexMultiplyAlpha(_vtx[2],self.opacity),transform));
	CCRenderBufferSetVertex(buffer, 3, CCVertexApplyTransform(CCVertexMultiplyAlpha(_vtx[3],self.opacity),transform));
	
	CCRenderBufferSetTriangle(buffer, 0, 0, 1, 2);
	CCRenderBufferSetTriangle(buffer, 1, 0, 3, 2);
}

@end