//
//  PlayerChargeIndicator.m
//  hanokam
//
//  Created by spotco on 02/06/2015.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "PlayerChargeIndicator.h"
#import "SPRadialFillSprite.h"
#import "Resource.h" 
#import "FileCache.h"
#import "GameEngineScene.h"
#import "Player.h"
#import "ControlManager.h"

typedef enum PlayerChargeIndicatorMode {
	PlayerChargeIndicatorMode_Hidden,
	PlayerChargeIndicatorMode_FadeIn,
	PlayerChargeIndicatorMode_Show,
	PlayerChargeIndicatorMode_FadeOut,
	PlayerChargeIndicatorMode_FadeOutFail
} PlayerChargeIndicatorMode;

@implementation PlayerChargeIndicator {
	SPRadialFillSprite *_radial_fill;
	CCSprite *_target;
	
	PlayerChargeIndicatorMode _current_mode;
	float _anim_t;
	float _hold_ct;
	float _tar_radial_fill_pct;
	
	float _target_pulse_size_ct;
}

+(PlayerChargeIndicator*)cons {
	return [[PlayerChargeIndicator node] cons];
}

-(PlayerChargeIndicator*)cons {
	_radial_fill = [SPRadialFillSprite cons_tex:[Resource get_tex:TEX_HUD_SPRITESHEET] rect:[FileCache get_cgrect_from_plist:TEX_HUD_SPRITESHEET idname:@"charge_circle.png"] norm_start:ccp(1,0) dir:-1];
	[_radial_fill set_pct:0];
	[_radial_fill setPosition:ccp(100,100)];
	[self addChild:_radial_fill];
	
	_target = [CCSprite spriteWithTexture:[Resource get_tex:TEX_HUD_SPRITESHEET] rect:[FileCache get_cgrect_from_plist:TEX_HUD_SPRITESHEET idname:@"charge_dot.png"]];
	[_target setScale:0.5];
	[_target setOpacity:0.75];
	[_radial_fill addChild:_target];
	
	[_radial_fill set_pct:0];
	_radial_fill.opacity = 0;
	_target.opacity = 0;
	
	_current_mode = PlayerChargeIndicatorMode_Hidden;
	
	return self;
}

-(void)i_update:(GameEngineScene*)game {
	[_radial_fill set_pct:drpt(_radial_fill.get_pct, _tar_radial_fill_pct, 1/2.0)];
	[_target setPosition:CGPointAdd(vec_to_cgpoint(vec_scale([_radial_fill get_target_direction],62.5)),[_radial_fill get_center])];
	
	[_radial_fill setPosition:[game.player convertToWorldSpace:CGPointZero]];
	_hold_ct -= dt_scale_get();
	
	_target_pulse_size_ct += fmodf(0.25 * dt_scale_get(),M_PI*2);
	
	_target.scale = sin(_target_pulse_size_ct)*0.3+0.6;
	
	switch (_current_mode) {
	case PlayerChargeIndicatorMode_Hidden:;
		_radial_fill.opacity = 0;
		_target.opacity = 0;
		_tar_radial_fill_pct = 0;
		[_radial_fill set_pct:0];
	break;
	case PlayerChargeIndicatorMode_FadeIn:;
		_anim_t += 0.1 * dt_scale_get();
		_radial_fill.opacity = lerp(0, 1, _anim_t);
		_target.opacity = lerp(0, 0.8, _anim_t);
		_radial_fill.scale = lerp(1.2, 1, _anim_t);
		if (_anim_t >= 1) {
			_current_mode = PlayerChargeIndicatorMode_Show;
		}
	break;
	case PlayerChargeIndicatorMode_Show:;
		_radial_fill.opacity = 1;
		_target.opacity = 0.8;
		_radial_fill.scale = 1;
		if (_hold_ct <= 0) {
			_current_mode = PlayerChargeIndicatorMode_FadeOut;
			_anim_t = 0;
		}
	break;
	case PlayerChargeIndicatorMode_FadeOut:;
		_anim_t += 0.1 * dt_scale_get();
		_radial_fill.opacity = lerp(1, 0, _anim_t);
		_target.opacity = lerp(0.8, 0, _anim_t);
		_radial_fill.scale = lerp(1, 2, _anim_t);
		if (_anim_t >= 1) {
			_current_mode = PlayerChargeIndicatorMode_Hidden;
		}
	break;
	case PlayerChargeIndicatorMode_FadeOutFail:;
		_anim_t += 0.2 * dt_scale_get();
		_radial_fill.opacity = lerp(1, 0, _anim_t);
		_target.opacity = lerp(0.8, 0, _anim_t);
		_radial_fill.scale = lerp(1,  0.5, _anim_t);
		if (_anim_t >= 1) {
			_current_mode = PlayerChargeIndicatorMode_Hidden;
		}
	break;
	}
}

-(void)set_pct:(float)pct g:(GameEngineScene*)g {
	_tar_radial_fill_pct = pct;
	if (_current_mode == PlayerChargeIndicatorMode_Hidden || _current_mode == PlayerChargeIndicatorMode_FadeOut) {
		_current_mode = PlayerChargeIndicatorMode_FadeIn;
		
		CGPoint p2td = g.get_control_manager.get_player_to_touch_dir;
		if (!(p2td.x == 0 && p2td.y == 0)) {
			[_radial_fill set_start_dir:p2td];
		}
	}
	_hold_ct = 5;
}

-(void)fadeout_fail {
	_current_mode = PlayerChargeIndicatorMode_FadeOutFail;
	_hold_ct = 0;
	_anim_t = 0;
}

@end
