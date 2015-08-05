//
//  BGWaterLineBelow.m
//  hanokam
//
//  Created by spotco on 05/08/2015.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "BGWaterLineBelow.h"
#import "Resource.h"
#import "Common.h"
#import "FileCache.h"
#import "CCTexture_Private.h"


@implementation BGWaterLineBelow {
	float _waterline_x;
	CCSprite *_waterline;
	
	CCSprite *_watergrad;
	
	float _belowline_lightrays_anim_theta;
	CCSprite *_belowline_lightrays;
}
+(BGWaterLineBelow*)cons {
	return [[BGWaterLineBelow node] cons];
}
-(BGWaterLineBelow*)cons {
	ccTexParams repeat_par = {GL_LINEAR, GL_LINEAR, GL_REPEAT, GL_CLAMP_TO_EDGE};
	CCTexture *waterline_tex = [Resource get_tex:TEX_BG_WATER_TOP_WATERLINE];
	[waterline_tex setTexParameters:&repeat_par];
	
	_waterline = [CCSprite spriteWithTexture:waterline_tex rect:CGRectMake(0, 0, waterline_tex.pixelWidth, waterline_tex.pixelHeight)];
	scale_to_fit_screen_x(_waterline);
	_waterline.scaleY = _waterline.scaleX;
	[_waterline setAnchorPoint:ccp(0,0.5)];
	[self addChild:_waterline z:1];
	
	_watergrad = [CCSprite spriteWithTexture:[Resource get_tex:TEX_BG_WATER_BOTTOM_SURFACEGRAD] rect:CGRectMake(0, 0, game_screen().width, 48)];
	[_watergrad setAnchorPoint:ccp(0,1)];
	[_watergrad setPosition:ccp(0,0)];
	[self addChild:_watergrad z:0];
	
	_belowline_lightrays = [CCSprite spriteWithTexture:[Resource get_tex:TEX_BG_SPRITESHEET_1] rect:[FileCache get_cgrect_from_plist:TEX_BG_SPRITESHEET_1 idname:@"bg_water_bottom_beams.png"]];
	scale_to_fit_screen_x(_belowline_lightrays);
	_belowline_lightrays.scaleX *= 0.9;
	_belowline_lightrays.scaleY = _belowline_lightrays.scaleX;
	[_belowline_lightrays setAnchorPoint:ccp(0.5,0.5)];
	[_belowline_lightrays setPosition:ccp(game_screen().width/2,90)];
	[_belowline_lightrays setOpacity:0.1];
	[self addChild:_belowline_lightrays z:2];
	
	return self;
}
-(void)i_update:(GameEngineScene*)g {
	_waterline_x = fmodf(_waterline_x+dt_scale_get()*(0.4), _waterline.textureRect.size.width);
	[_waterline setTextureRect:CGRectMake(
		_waterline_x,
		_waterline.textureRect.origin.y,
		_waterline.textureRect.size.width,
		_waterline.textureRect.size.height
	)];
	_belowline_lightrays_anim_theta += 0.075 * dt_scale_get();
	[_belowline_lightrays setOpacity:(cosf(_belowline_lightrays_anim_theta)+1)/2 * 0.5 + 0.4];
}
@end
