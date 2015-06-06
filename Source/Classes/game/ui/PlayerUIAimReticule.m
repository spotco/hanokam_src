//
//  PlayerUIAimReticule.m
//  hanokam
//
//  Created by spotco on 05/06/2015.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "PlayerUIAimReticule.h"
#import "GameEngineScene.h"
#import "Player.h"
#import "Resource.h" 
#import "FileCache.h"
#import "ShaderManager.h"

@implementation PlayerUIAimReticule {
	CCSprite *_left_line, *_right_line;
}

+(PlayerUIAimReticule*)cons {
	return [[PlayerUIAimReticule node] cons];
}

void set_alpha_gradient_properties(CCSprite *obj) {
	obj.shaderUniforms[@"start_x"] = @([obj convertToWorldSpace:CGPointZero].x);
	obj.shaderUniforms[@"start_y"] = @(obj.position.y);
	obj.shaderUniforms[@"start_alpha_x"] = @(0);
	obj.shaderUniforms[@"end_alpha_x"] = @(1);
	obj.shaderUniforms[@"start_alpha_y"] = @(1);
	obj.shaderUniforms[@"end_alpha_y"] = @(1);
	obj.shaderUniforms[@"width"] = @(obj.textureRect.size.width);
	obj.shaderUniforms[@"height"] = @(obj.textureRect.size.height);
}

-(PlayerUIAimReticule*)cons {
	
	_left_line = [CCSprite spriteWithTexture:[Resource get_tex:TEX_BLANK]];
	[_left_line setTextureRect:CGRectMake(0, 0, 2, 200)];
	[_left_line setAnchorPoint:ccp(0.5,0)];
	[_left_line setBlendMode:[CCBlendMode alphaMode]];
	[_left_line setShader:[ShaderManager get_shader:SHADER_ALPHA_GRADIENT]];
	
	set_alpha_gradient_properties(_left_line);
	
	[self addChild:_left_line];

	return self;
}

-(void)i_update:(GameEngineScene*)g {
	[self setPosition:[g.player convertToWorldSpace:CGPointZero]];
}

@end
