//
//  SPRadialFillSprite.m
//  hanokam
//
//  Created by spotco on 01/06/2015.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "SPRadialFillSprite.h"
#import "CCTexture_Private.h"
#import "ShaderManager.h" 

@implementation SPRadialFillSprite {
	float _pct;
	
	float _dir;
	Vec3D _start_dir;
	
	int _num_triangles;
	CCVertex *_verts;
}

+(SPRadialFillSprite*)cons_tex:(CCTexture*)texture rect:(CGRect)rect norm_start:(CGPoint)norm_start dir:(float)dir {
	return [[SPRadialFillSprite node] cons_tex:texture rect:rect norm_start:norm_start dir:dir];
}

-(SPRadialFillSprite*)cons_tex:(CCTexture*)texture rect:(CGRect)rect norm_start:(CGPoint)norm_start dir:(float)dir {
	[self setTexture:texture];
	[self setTextureRect:rect];
	_dir = dir;
	_start_dir = vec_cons_norm(norm_start.x, norm_start.y, 0);
	[self set_pct:1];
	_num_triangles = 30;
	_verts = calloc(sizeof(CCVertex), _num_triangles*3);
	[self setBlendMode:[CCBlendMode alphaMode]];
	[self setShader:[ShaderManager get_shader:SHADER_CHARGE_CIRCLE]];
	[self calc_triangles];
	
	return self;
}

-(void)set_start_dir:(CGPoint)norm_start {
	_start_dir = vec_cons_norm(norm_start.x, norm_start.y, 0);
	[self calc_triangles];
}

-(SPRadialFillSprite*)set_pct:(float)pct {
	_pct = clampf(pct,0,1);
	return self;
}

-(float)get_pct {
	return _pct;
}



-(void)calc_triangles {
	float dir_rad_itr = (M_PI * 2)/_num_triangles * -_dir;
	Vec3D dir = _start_dir;
	CGPoint center = ccp(self.textureRect.size.width/2,self.textureRect.size.height/2);
	CGPoint last = point_box_intersection(self.textureRect.size, dir);
	CCVertex vert;
	
	CGRange tex_coord_x_range, tex_coord_y_range;
	tex_coord_x_range.min = self.textureRect.origin.x / self.texture.pixelWidth;
	tex_coord_x_range.max = (self.textureRect.origin.x + self.textureRect.size.width) / self.texture.pixelWidth;
	
	tex_coord_y_range.max = 1-self.textureRect.origin.y / self.texture.pixelHeight;
	tex_coord_y_range.min = 1-(self.textureRect.origin.y + self.textureRect.size.height) / self.texture.pixelHeight;
	
	float tar_alpha = 0.1;
	
	for (int i = 0; i < _num_triangles; i++) {
		vert.position = GLKVector4Make(center.x, center.y, 0, 1);
		vert.texCoord1 = GLKVector2Make(
			lerp(tex_coord_x_range.min,tex_coord_x_range.max,vert.position.x/self.textureRect.size.width),
			lerp(tex_coord_y_range.min,tex_coord_y_range.max,vert.position.y/self.textureRect.size.height));
		vert.color = GLKVector4Make(1, 1, 1, tar_alpha);
		_verts[i*3+0] = vert;
		
		vert.position = GLKVector4Make(last.x, last.y, 0, 1);
		vert.texCoord1 = GLKVector2Make(
			lerp(tex_coord_x_range.min,tex_coord_x_range.max,vert.position.x/self.textureRect.size.width),
			lerp(tex_coord_y_range.min,tex_coord_y_range.max,vert.position.y/self.textureRect.size.height));
		vert.color = GLKVector4Make(1, 1, 1, tar_alpha);
		_verts[i*3+1] = vert;
		
		dir = vec_rotate_rad(dir, dir_rad_itr);
		last = point_box_intersection(self.textureRect.size, dir);
		vert.position = GLKVector4Make(last.x, last.y, 0, 1);
		vert.texCoord1 = GLKVector2Make(
			lerp(tex_coord_x_range.min,tex_coord_x_range.max,vert.position.x/self.textureRect.size.width),
			lerp(tex_coord_y_range.min,tex_coord_y_range.max,vert.position.y/self.textureRect.size.height));
		vert.color = GLKVector4Make(1, 1, 1, tar_alpha);
		_verts[i*3+2] = vert;
		
		tar_alpha = clampf(tar_alpha+0.1, 0, 1);
	}
}

-(void)dealloc {
	free(_verts);
}

-(void)draw:(CCRenderer *)renderer transform:(const GLKMatrix4 *)transform {
	self.shaderUniforms[@"overallAlpha"] = [NSNumber numberWithFloat:self.opacity];
	CCRenderBuffer buffer = [renderer enqueueTriangles:_num_triangles andVertexes:_num_triangles*3 withState:self.renderState globalSortOrder:0];
	CCVertex empty_vert;
	for (int i = 0; i < _num_triangles; i++) {
		if (i < _num_triangles * _pct) {
			CCRenderBufferSetVertex(buffer, i*3+0, CCVertexApplyTransform(_verts[i*3+0], transform));
			CCRenderBufferSetVertex(buffer, i*3+1, CCVertexApplyTransform(_verts[i*3+1], transform));
			CCRenderBufferSetVertex(buffer, i*3+2, CCVertexApplyTransform(_verts[i*3+2], transform));
		} else {
			CCRenderBufferSetVertex(buffer, i*3+0, CCVertexApplyTransform(empty_vert, transform));
			CCRenderBufferSetVertex(buffer, i*3+1, CCVertexApplyTransform(empty_vert, transform));
			CCRenderBufferSetVertex(buffer, i*3+2, CCVertexApplyTransform(empty_vert, transform));
		}
		CCRenderBufferSetTriangle(buffer, i, i*3+0, i*3+1, i*3+2);
	}
}

-(Vec3D)get_target_direction {
	Vec3D start = _start_dir;
	return vec_rotate_rad(start, M_PI*2*(_pct + 0.01)*-_dir);
}

-(CGPoint)get_center {
	return ccp(self.textureRect.size.width/2,self.textureRect.size.height/2);
}

@end
