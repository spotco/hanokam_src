//
//  DiveUI.m
//  hanokam
//
//  Created by spotco on 30/06/2015.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "DiveUI.h"
#import "HealthBar.h"
#import "Common.h"
#import "Player.h"
#import "FlashCount.h"
#import "WaterEnemyManager.h"
#import "Resource.h"
#import "FileCache.h"
#import "SPLabel.h"

@implementation DiveUI {
	float _current_fill_pct;
	
	ccColor4F _breath_bar_back_color, _breath_bar_fill_color, _breath_bar_fill_hit_color;
	float _breath_bar_anim_t;
	
	CCSprite *_breath_bar;
	SPLabel *_air_text;
	
	FlashCount *_low_breath_flash;
	
	SPLabel *_depth_text;
	SPLabel *_enemies_attracted_text;
	//CCLabelTTF *_depth_text;
	//CCLabelTTF *_enemies_attracted_text;
}
+(DiveUI*)cons:(GameEngineScene*)g {
	return [[DiveUI node] cons:g];
}

-(DiveUI*)cons:(GameEngineScene*)g {
	CCSprite *breath_bar_back = [CCSprite spriteWithTexture:[Resource get_tex:TEX_HUD_SPRITESHEET] rect:[FileCache get_cgrect_from_plist:TEX_HUD_SPRITESHEET idname:@"UI_Air-gauge.png"]];
	scale_to_fit_screen_x(breath_bar_back);
	breath_bar_back.scaleY = breath_bar_back.scaleX;
	[breath_bar_back set_anchor_pt:ccp(0,1)];
	[breath_bar_back setPosition:game_screen_anchor_offset(ScreenAnchor_TL, ccp(0,-5))];
	[breath_bar_back setColor4f:ccc4f(0.1, 0.1, 0.25, 0.75)];
	[self addChild:breath_bar_back];

	_breath_bar = [CCSprite spriteWithTexture:[Resource get_tex:TEX_HUD_SPRITESHEET]];
	_breath_bar.scale = breath_bar_back.scale;
	[_breath_bar set_anchor_pt:breath_bar_back.anchorPoint];
	[_breath_bar setPosition:breath_bar_back.position];
	[self addChild:_breath_bar];
	
	[self set_breath_pct:1.0];
	
	[self addChild:[[[[CCSprite spriteWithTexture:[Resource get_tex:TEX_HUD_SPRITESHEET] rect:[FileCache get_cgrect_from_plist:TEX_HUD_SPRITESHEET idname:@"UI_Air-icon.png"]]
		set_anchor_pt:ccp(0,1)]
		set_pos:game_screen_anchor_offset(ScreenAnchor_TL, ccp(2,-2))] set_scale:0.25]];
	
	_air_text = [SPLabel cons_texkey:TEX_HUD_FONT];
	[_air_text setPosition:game_screen_anchor_offset(ScreenAnchor_TL, ccp(65,-19))];
	[_air_text set_fillcolor:ccc4f(62/255.0, 56/255.0, 64/255.0, 1.0) strokecolor:ccc4f(189/255.0, 247/255.0, 255/255.0, 1.0)];
	[_air_text set_string:@"100%"];
	[_air_text setScale:0.45];
	[self addChild:_air_text];
	
	_breath_bar_fill_color = ccc4f(1,1,1,1);
	_breath_bar_fill_hit_color = ccc4f(220.0/255, 120.0/255, 150.0/255, 1.0);
	_breath_bar_anim_t = 0.0;
	_current_fill_pct = 1.0;
    [self set_breath_pct:_current_fill_pct];
	
	[g.get_event_dispatcher add_listener:self];
	
	_low_breath_flash = [FlashCount cons];
	[_low_breath_flash add_flash_at_times:@[@(0.3),@(0.2),@(0.15),@(0.1),@(0.05)]];
	
	//
	CCSprite *depth_text_back = [CCSprite spriteWithTexture:[Resource get_tex:TEX_HUD_SPRITESHEET] rect:[FileCache get_cgrect_from_plist:TEX_HUD_SPRITESHEET idname:@"UI_Depth-BG.png"]];
	[depth_text_back setScale:0.2];
	[depth_text_back set_anchor_pt:ccp(0,1)];
	[depth_text_back set_pos:game_screen_anchor_offset(ScreenAnchor_TL, ccp(0,-40))];
	[self addChild:depth_text_back];
	
	CCSprite *depth_text_icon = [CCSprite spriteWithTexture:[Resource get_tex:TEX_HUD_SPRITESHEET] rect:[FileCache get_cgrect_from_plist:TEX_HUD_SPRITESHEET idname:@"UI_Depth-icon.png"]];
	[depth_text_icon setScale:0.2];
	[depth_text_icon set_anchor_pt:ccp(0,1)];
	[depth_text_icon set_pos:game_screen_anchor_offset(ScreenAnchor_TL, ccp(0,-45))];
	[self addChild:depth_text_icon];
	
	
	_depth_text = [SPLabel cons_texkey:TEX_HUD_FONT];
	[_depth_text setPosition:game_screen_anchor_offset(ScreenAnchor_TL, ccp(55,-53))];
	[_depth_text set_fillcolor:ccc4f(239/255.0, 213/255.0, 241/255.0, 1.0) strokecolor:ccc4f(62/255.0, 48/255.0, 33/255.0, 1.0)];
	[_depth_text add_char_offset:'m' size_increase:ccp(0,0) offset:ccp(10,-16)];
	[_depth_text setScale:0.5];
	[_depth_text set_string:@"0m"];
	[self addChild:_depth_text];
	
	
	//
	CCSprite *enemies_attracted_text_back = [CCSprite spriteWithTexture:[Resource get_tex:TEX_HUD_SPRITESHEET] rect:[FileCache get_cgrect_from_plist:TEX_HUD_SPRITESHEET idname:@"UI_Enemy-BG.png"]];
	[enemies_attracted_text_back setScale:0.2];
	[enemies_attracted_text_back set_anchor_pt:ccp(0,1)];
	[enemies_attracted_text_back set_pos:game_screen_anchor_offset(ScreenAnchor_TL, ccp(0,-43))];
	[self addChild:enemies_attracted_text_back];
	
	CCSprite *enemies_attracted_text_icon = [CCSprite spriteWithTexture:[Resource get_tex:TEX_HUD_SPRITESHEET] rect:[FileCache get_cgrect_from_plist:TEX_HUD_SPRITESHEET idname:@"UI_Enemy-icon.png"]];
	[enemies_attracted_text_icon setScale:0.2];
	[enemies_attracted_text_icon set_anchor_pt:ccp(0,1)];
	[enemies_attracted_text_icon set_pos:game_screen_anchor_offset(ScreenAnchor_TL, ccp(0,-68))];
	[self addChild:enemies_attracted_text_icon];
	
	_enemies_attracted_text = [SPLabel cons_texkey:TEX_HUD_FONT];
	[_enemies_attracted_text setPosition:game_screen_anchor_offset(ScreenAnchor_TL, ccp(55,-90))];
	[_enemies_attracted_text set_fillcolor:ccc4f(146/255.0, 221/255.0, 117/255.0, 1.0) strokecolor:ccc4f(62/255.0, 48/255.0, 33/255.0, 1.0)];
	[_enemies_attracted_text setScale:0.75];
	[_enemies_attracted_text set_string:@"0"];
	[self addChild:_enemies_attracted_text];
    return self;
}

-(void)dispatch_event:(GEvent *)e {
	if (e.type == GEventType_ModeDiveStart) {
		_current_fill_pct = 1.0;
		[_breath_bar setColor4f:_breath_bar_fill_color];
		[_low_breath_flash reset];
	}
	if (!self.visible) return;
	switch (e.type) {
	case GEventType_PlayerTakeDamage:{
		_breath_bar_anim_t = 1;
	} break;
	default: break;
	}
}

-(void)set_breath_pct:(float)pct {
	CGRect barrect = [FileCache get_cgrect_from_plist:TEX_HUD_SPRITESHEET idname:@"UI_Air-gauge.png"];
	barrect.size.width *= pct;
	[_breath_bar setTextureRect:barrect];
	[_air_text set_string:strf("%d%%",(int)(pct*100))];
}

-(void)i_update:(GameEngineScene *)g {
	
	_current_fill_pct = drpt(_current_fill_pct, g.player.shared_params.get_current_breath/g.player.shared_params.get_max_breath, 1/10.0);
    [self set_breath_pct:_current_fill_pct];
	
	[_enemies_attracted_text set_string:strf("%d",g.get_water_enemy_manager.get_enemies_attracted_count)];
	[_depth_text set_string:strf("%dm",((int)ABS(g.player.position.y))/50)];
	
	
	if ([_low_breath_flash do_flash_given_time:_current_fill_pct]) {
		_breath_bar_anim_t = 1;
	}
	
	_breath_bar_anim_t = MAX(_breath_bar_anim_t-=dt_scale_get()*0.035,0);
	float fill_color_pct = bezier_point_for_t(ccp(0,0), ccp(0,0.75), ccp(0,1), ccp(1,1), _breath_bar_anim_t).y;
	
	ccColor4F tar_color = ccc4f(
		lerp(_breath_bar_fill_color.r, _breath_bar_fill_hit_color.r, fill_color_pct),
		lerp(_breath_bar_fill_color.g, _breath_bar_fill_hit_color.g, fill_color_pct),
		lerp(_breath_bar_fill_color.b, _breath_bar_fill_hit_color.b, fill_color_pct),
		1.0
	);
	[_breath_bar setColor4f:tar_color];
}
@end
