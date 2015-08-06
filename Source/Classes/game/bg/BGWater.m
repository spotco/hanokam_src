//
//  BGWater.m
//  hobobob
//
//  Created by spotco on 15/03/2015.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "BGWater.h"
#import "Common.h"
#import "Resource.h"
#import "CCTexture_Private.h"
#import "FileCache.h"
#import "GameEngineScene.h"
#import "Player.h"
#import "ShaderManager.h"
#import "BGVillage.h"
#import "BGReflection.h"
#import "UnderwaterTreasureSprite.h"
#import "BGWaterLineAbove.h"
#import "BGWaterLineBelow.h"

@implementation BGWater {
	CCSprite *_water_bg;
	CCSprite *_ground, *_ground_fill;
	CCSprite *_top_cliff;
	CCSprite *_bg_2_ground,*_bg_3_ground; //shallow water elements connected to sky_bg elements
	
	CCSprite *_underwater_element_1, *_underwater_element_2, *_underwater_element_3;
	float _offset_underwater_element_1, _offset_underwater_element_2, _offset_underwater_element_3;
	CCSprite *_top_fade, *_bottom_fade;
	
	UnderwaterTreasureSprite *_underwater_temple_treasure;
	
	CCRenderTexture *_reflection_texture, *_ripple_texture;
	
	BGWaterLineAbove *_waterlineabove;
	BGWaterLineBelow *_waterlinebelow;
	
	CCSprite *_surface_gradient;
	CCRenderTexture *_above_water_belowreflection;
	CCRenderTexture *_water_surface_ripples;
}
+(BGWater*)cons:(GameEngineScene *)g {
	return (BGWater*)[[[BGWater alloc] init] cons:g];
}
-(BGWater*)cons:(GameEngineScene *)g {
	_water_bg = (CCSprite*)[[CCSprite node] add_to:[g get_anchor] z:GameAnchorZ_BGWater_RepeatBG];
	[_water_bg setTexture:[Resource get_tex:TEX_TEST_BG_TILE_WATER]];
	[_water_bg set_anchor_pt:ccp(0, 0)];
	ccTexParams repeat_par = {GL_LINEAR, GL_LINEAR, GL_REPEAT, GL_REPEAT};
	[_water_bg.texture setTexParameters:&repeat_par];
	[_water_bg setPosition:ccp(0,0)];
	[_water_bg setTextureRect:CGRectMake(0, 0, game_screen().width, game_screen().height)];
	
	_underwater_element_3 = [self cons_underwater_element:g rect:@"underwater_bg_3.png"];
	_underwater_element_2 = [self cons_underwater_element:g rect:@"underwater_bg_2.png"];
	_underwater_element_1 = [self cons_underwater_element:g rect:@"underwater_bg_1.png"];
	_offset_underwater_element_1 = float_random(0, 2048);
	_offset_underwater_element_2 = float_random(0, 2048);
	_offset_underwater_element_3 = float_random(0, 2048);
	
	ccTexParams repeat_x_par = {GL_LINEAR, GL_LINEAR, GL_REPEAT, GL_CLAMP_TO_EDGE};
	_top_fade = [CCSprite spriteWithTexture:[Resource get_tex:TEX_BG_WATER_ELEMENT_FADE]];
	[_top_fade.texture setTexParameters:&repeat_x_par];
	[_top_fade setTextureRect:CGRectMake(0, 0, game_screen().width, _top_fade.texture.pixelHeight)];
	[_top_fade setScaleY:-1 * 0.75];
	[_top_fade setAnchorPoint:ccp(0,0)];
	CGRect top_cliff_rect = [FileCache get_cgrect_from_plist:TEX_BG_SPRITESHEET_1 idname:@"pier_bottom_cliff.png"];
	[_top_fade setPosition:ccp(0,-top_cliff_rect.size.height*0.5+150)];
	[[g get_anchor] addChild:_top_fade z:GameAnchorZ_BGWater_Ground];
	
	_bottom_fade = [CCSprite spriteWithTexture:[Resource get_tex:TEX_BG_WATER_ELEMENT_FADE]];
	[_bottom_fade setTextureRect:CGRectMake(0, 0, game_screen().width, _bottom_fade.texture.pixelHeight)];
	[_bottom_fade setAnchorPoint:ccp(0,0)];
	[_bottom_fade setScaleY:0.75];
	[[g get_anchor] addChild:_bottom_fade z:GameAnchorZ_BGWater_Ground];

	
	_ground = [CCSprite spriteWithTexture:[Resource get_tex:TEX_BG_SPRITESHEET_1] rect:[FileCache get_cgrect_from_plist:TEX_BG_SPRITESHEET_1 idname:@"underwater_temple.png"]];
	scale_to_fit_screen_x(_ground);
	_ground.scaleY = _ground.scaleX;
	[_ground setAnchorPoint:ccp(0,1)];
	
	_ground_fill = [CCSprite spriteWithTexture:[Resource get_tex:TEX_BLANK]];
	[_ground_fill setColor:[CCColor colorWithCcColor3b:ccc3(5, 44, 92)]];
	[_ground_fill setAnchorPoint:ccp(0,0)];
	[[g get_anchor] addChild:_ground_fill z:GameAnchorZ_BGWater_Ground];
	[[g get_anchor] addChild:_ground z:GameAnchorZ_BGWater_Ground];
	
	_underwater_temple_treasure = [UnderwaterTreasureSprite cons];
	[[g get_anchor] addChild:_underwater_temple_treasure z:GameAnchorZ_UnderwaterForegroundElements];
	
	[self set_ground_depth:-9999];
	
	[self initialize_reflection_and_ripples:g];
	
	_bg_3_ground = [CCSprite spriteWithTexture:[Resource get_tex:TEX_BG_SPRITESHEET_1] rect:[FileCache get_cgrect_from_plist:TEX_BG_SPRITESHEET_1 idname:@"bg_underwater_3.png"]];
	scale_to_fit_screen_x(_bg_3_ground);
	[_bg_3_ground setPosition:ccp(0,0)];
	[_bg_3_ground setScaleY:_bg_3_ground.scaleX];
	[_bg_3_ground setAnchorPoint:ccp(0,1)];
	[[g get_anchor] addChild:_bg_3_ground z:GameAnchorZ_BGWater_I1];
	
	_bg_2_ground = [CCSprite spriteWithTexture:[Resource get_tex:TEX_BG_SPRITESHEET_1] rect:[FileCache get_cgrect_from_plist:TEX_BG_SPRITESHEET_1 idname:@"bg_underwater_2.png"]];
	scale_to_fit_screen_x(_bg_2_ground);
	[_bg_2_ground setPosition:ccp(0,0)];
	[_bg_2_ground setScaleY:_bg_2_ground.scaleX];
	[_bg_2_ground setAnchorPoint:ccp(0,1)];
	[[g get_anchor] addChild:_bg_2_ground z:GameAnchorZ_BGWater_I1];
	
	_top_cliff = [CCSprite spriteWithTexture:[Resource get_tex:TEX_BG_SPRITESHEET_1] rect:[FileCache get_cgrect_from_plist:TEX_BG_SPRITESHEET_1 idname:@"pier_bottom_cliff.png"]];
	scale_to_fit_screen_x(_top_cliff);
	[_top_cliff setPosition:ccp(0,15)];
	[_top_cliff setScaleY:_top_cliff.scaleX];
	[_top_cliff setAnchorPoint:ccp(0,1)];
	[[g get_anchor] addChild:_top_cliff z:GameAnchorZ_BGWater_I1];
	
	_waterlineabove = [BGWaterLineAbove cons];
	[_waterlineabove setPosition:ccp(0,-80)];
	[[g get_anchor] addChild:_waterlineabove z:GameAnchorZ_BGWater_WaterLineAbove];
	
	_waterlinebelow = [BGWaterLineBelow cons];
	[_waterlinebelow setPosition:ccp(0,0)];
	[[g get_anchor] addChild:_waterlinebelow z:GameAnchorZ_BGWater_WaterLineBelow];
	
	[self cons_surface_reflection:g];
	
	return self;
}

-(void)cons_surface_reflection:(GameEngineScene*)g {
	_surface_gradient = [CCSprite spriteWithTexture:[Resource get_tex:TEX_TEST_BG_UNDERWATER_SURFACE_GRADIENT]];
	[[g get_anchor] addChild:_surface_gradient z:GameAnchorZ_BGSky_SurfaceGradient];
	[_surface_gradient setOpacity:1];
	[_surface_gradient setTextureRect:CGRectMake(0, 0, game_screen().width, _surface_gradient.texture.pixelHeight)];
	[_surface_gradient setAnchorPoint:ccp(0,0)];
	[_surface_gradient setPosition:ccp(0,0)];
	[_surface_gradient setVisible:NO];
	
	int reflection_height = 600;
	_water_surface_ripples = [CCRenderTexture renderTextureWithWidth:game_screen().width height:reflection_height pixelFormat:CCTexturePixelFormat_RGBA4444];
	[_above_water_belowreflection setPosition:ccp(game_screen().width / 2, reflection_height/2)];
	[_water_surface_ripples clear:0 g:0 b:0 a:0];
	
	_above_water_belowreflection = [CCRenderTexture renderTextureWithWidth:game_screen().width height:reflection_height pixelFormat:CCTexturePixelFormat_RGBA4444];
	[_above_water_belowreflection setPosition:ccp(game_screen().width / 2, reflection_height/2)];
	[[g get_anchor] addChild:_above_water_belowreflection z:GameAnchorZ_BGSky_SurfaceReflection];
	_above_water_belowreflection.sprite.shader = [CCShader shaderNamed:SHADER_ABOVEWATER_AM_UP];
	_above_water_belowreflection.sprite.shaderUniforms[@"testTime"] = [g get_tick_mod_pi];
	_above_water_belowreflection.sprite.shaderUniforms[@"rippleTexture"] = _water_surface_ripples.sprite.texture;
	
	_above_water_belowreflection.sprite.blendMode = [CCBlendMode alphaMode];
}

-(CCSprite*)cons_underwater_element:(GameEngineScene*)g rect:(NSString*)rect  {
	CCSprite *rtv = (CCSprite*)[[CCSprite node] add_to:[g get_anchor] z:GameAnchorZ_BGWater_Elements];
	[rtv setTexture:[Resource get_tex:TEX_BG_UNDERWATER_SPRITESHEET]];
	[rtv setTextureRect:[FileCache get_cgrect_from_plist:TEX_BG_UNDERWATER_SPRITESHEET idname:rect]];
	[rtv set_anchor_pt:ccp(0,0)];
	[rtv setPosition:ccp(0,0)];
	scale_to_fit_screen_x(rtv);
	rtv.scaleY = rtv.scaleX;
	ccTexParams repeat_par = {GL_LINEAR, GL_LINEAR, GL_REPEAT, GL_REPEAT};
	[rtv.texture setTexParameters:&repeat_par];
	return rtv;
}

-(void)initialize_reflection_and_ripples:(GameEngineScene*)game {
	_reflection_texture = [CCRenderTexture renderTextureWithWidth:game_screen().width height:game.REFLECTION_HEIGHT pixelFormat:CCTexturePixelFormat_RGBA4444];
	[_reflection_texture setPosition:ccp(game_screen().width / 2, 0)];
	_reflection_texture.scaleY = -1;
	[[game get_anchor] addChild:_reflection_texture z:GameAnchorZ_BGWater_Reflection];
	_reflection_texture.sprite.blendMode = [CCBlendMode alphaMode];
	_reflection_texture.sprite.shader = [ShaderManager get_shader:SHADER_REFLECTION_AM_DOWN];
	_ripple_texture = [CCRenderTexture renderTextureWithWidth:game_screen().width height:game.REFLECTION_HEIGHT pixelFormat:CCTexturePixelFormat_RGBA4444];
	[_ripple_texture clear:0 g:0 b:0 a:0];
	_reflection_texture.sprite.shaderUniforms[@"rippleTexture"] = _ripple_texture.sprite.texture;
	
	[_reflection_texture.sprite setVisible:YES];
}

-(void)render_ripple_texture:(GameEngineScene*)game {
	[_ripple_texture clear:0 g:0 b:0 a:0];
	[_ripple_texture begin];
	for (RippleInfo *itr in game.get_ripple_infos) {
		[itr render_reflected:game.get_ripple_proto offset:ccp(0,0) scymult:0.5];
	}
	[_ripple_texture end];
	
}

-(void)render_reflection_texture:(GameEngineScene*)game {
	[_reflection_texture clear:0 g:0 b:0 a:0];
	[_reflection_texture begin];
	[game.get_bg_village render_reflection:game offset:_reflection_texture.position];
	
	if (game.player.position.y > -10 && [game get_player_state] != PlayerState_InAir) {
		[BGReflection reflection_render:game.player offset:ccp(0,game.HORIZON_HEIGHT/2 - _reflection_texture.position.y) g:game];
	}
	[_reflection_texture end];
	
	float camera_y = game.get_current_camera_center_y;
	[_reflection_texture setPosition:ccp(_reflection_texture.position.x, clampf(camera_y*.24-25,0,game.HORIZON_HEIGHT))];
}

-(void)update_underwater_element:(CCSprite*)element g:(GameEngineScene*)g mult:(float)mult offset:(float)offset {
	[element setVisible:YES];
	[element setPosition:ccp(0,g.get_viewbox.y1)];
	
	float posy = -g.get_current_camera_center_y * mult;
	float m_ypos = ((int)(posy))%element.texture.pixelHeight + ((posy) - ((int)(posy)));
	
	[element setTextureRect:CGRectMake(
		element.textureRect.origin.x,
		m_ypos + offset,
		element.textureRect.size.width,
		element.textureRect.size.height
	)];
}

-(void)set_ground_depth:(float)depth {
	[_ground setPosition:ccp(0, depth+120)];
	[_bottom_fade setPosition:ccp(0,depth+120-140)];
	[_ground_fill setPosition:ccp(0, depth+120-140-game_screen().height)];
	[_ground_fill setTextureRect:CGRectMake(0, 0, game_screen().width, game_screen().height)];
	[_underwater_temple_treasure setPosition:ccp(game_screen().width*0.5, depth+20)];
}
-(CGPoint)get_underwater_treasure_position { return _underwater_temple_treasure.position; }
-(void)set_underwater_treasure_visible:(BOOL)tar { [_underwater_temple_treasure setVisible:tar]; }

-(void)update_surface_reflection:(GameEngineScene*)g {
	if ([g.player is_underwater:g] && g.get_current_camera_center_y > -game_screen().height) {
		[_water_surface_ripples clear:0 g:0 b:0 a:0];
		[_water_surface_ripples begin];
		CCSprite *proto = g.get_ripple_proto;
		for (RippleInfo *itr in g.get_ripple_infos) {
			[itr render_default:proto offset:ccp(0,65) scymult:0.35];
		}
		[_water_surface_ripples end];
		
		
		[_above_water_belowreflection beginWithClear:0 g:0 b:0 a:0];
		
		[g.get_bg_village render_underwater_reflection];
		[_surface_gradient setVisible:YES];
		[_surface_gradient setOpacity:0.65];
		[_surface_gradient visit];
		[_surface_gradient setOpacity:1.0];
		[_surface_gradient setVisible:NO];
		
		{
			CGPoint player_pre = g.player.position;
			float player_scale_pre = g.player.scaleY;
			g.player.position = ccp(player_pre.x,-player_pre.y);
			g.player.scaleY = -player_scale_pre;
			[g.player visit];
			g.player.position = player_pre;
			g.player.scaleY = player_scale_pre;
		}
		
		[_above_water_belowreflection end];
		_above_water_belowreflection.sprite.shaderUniforms[@"testTime"] = [g get_tick_mod_pi];
		
		float view_top = g.get_viewbox.y2;
		if (view_top > 0) {
			_surface_gradient.scaleY = view_top/_surface_gradient.texture.pixelHeight + 0.1;
		}
		[_surface_gradient setVisible:YES];
		[_above_water_belowreflection setVisible:YES];
		
	} else {
		[_surface_gradient setVisible:NO];
		[_above_water_belowreflection setVisible:NO];
	}
}

-(void)i_update:(GameEngineScene*)g {
	[self update_surface_reflection:g];
	[_water_bg setPosition:ccp(0, g.get_current_camera_center_y - game_screen().height / 2)];
	
	_bg_2_ground.position = ccp(_bg_2_ground.position.x,clampf(g.get_current_camera_center_y * .2 + 5, 20,200));
	_bg_3_ground.position = ccp(_bg_3_ground.position.x,g.get_current_camera_center_y*.25 + 15);
	
	if (g.get_viewbox.y1 > -180) {
		[_underwater_element_1 setVisible:NO];
		[_underwater_element_2 setVisible:NO];
		[_underwater_element_3 setVisible:NO];
		[_ground setVisible:NO];
		[_bottom_fade setVisible:NO];
		[_ground_fill setVisible:NO];
		
	} else {
		[self update_underwater_element:_underwater_element_1 g:g mult:1 offset:_offset_underwater_element_1];
		[self update_underwater_element:_underwater_element_2 g:g mult:0.6 offset:_offset_underwater_element_2];
		[self update_underwater_element:_underwater_element_3 g:g mult:0.4 offset:_offset_underwater_element_3];
		
		[_ground setVisible:YES];
		[_bottom_fade setVisible:YES];
		[_ground_fill setVisible:YES];
	}
	
	if (![g.player is_underwater:g]) {
		if ([g get_viewbox].y1 < g.HORIZON_HEIGHT && [g get_viewbox].y2 > -g.REFLECTION_HEIGHT) {
			[self render_ripple_texture:g];
			[self render_reflection_texture:g];
			_reflection_texture.sprite.shaderUniforms[@"testTime"] = [g get_tick_mod_pi];
		}
		[_reflection_texture setVisible:YES];
	} else {
		[_reflection_texture setVisible:NO];
	}
	
	if ([g.player is_underwater:g]) {
		[_waterlineabove setVisible:NO];
		
		[_waterlinebelow setVisible:YES];
		[_waterlinebelow i_update:g];
	} else {
		[_waterlineabove setVisible:YES];
		[_waterlineabove i_update:g];
		
		[_waterlinebelow setVisible:NO];
	}
	[self set_waterline_above_position:g];
}

-(void)set_waterline_above_position:(GameEngineScene*)g {
	[_waterlineabove setPosition:ccp(
		_waterlineabove.position.x,
		clampf(
			y_for_point_of_2pt_line(ccp(150,-80), ccp(0,0), g.get_current_camera_center_y),
			-1000,-20)
		)
	];
}

@end
