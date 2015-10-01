//
//  TouchButton.m
//  hanokam
//
//  Created by spotco on 14/08/2015.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "TouchButton.h"
#import "GameEngineScene.h"
#import "Common.h"
#import "ControlManager.h"

@implementation TouchButton {
	CCSprite *_sprite;
	CallBack *_callback;
	
	float _sprite_default_scale;
	
	HitRect _hitrect;
}

+(TouchButton*)cons_sprite:(CCSprite*)sprite callback:(CallBack*)callback {
	return [[TouchButton node] cons_sprite:sprite callback:callback];
}

-(TouchButton*)cons_sprite:(CCSprite*)sprite callback:(CallBack*)callback {
	_sprite = sprite;
	_callback = callback;
	_sprite_default_scale = _sprite.scale;
	
	[self addChild:_sprite];
	return self;
}

-(void)reset {
	[_sprite setScale:_sprite_default_scale];
}

-(void)update_hit_rect {
	float prev_scale = _sprite.scale;
	_sprite.scale = _sprite_default_scale;
	CGPoint bl_point = [self convertToWorldSpace:_sprite.boundingBox.origin];
	CGPoint tr_point = [self convertToWorldSpace:CGPointAdd(_sprite.boundingBox.origin, ccp(_sprite.boundingBox.size.width,_sprite.boundingBox.size.height))];
	_hitrect = hitrect_cons_x1y1_x2y2(bl_point.x, bl_point.y, tr_point.x, tr_point.y);
	_sprite.scale = prev_scale;
}

-(void)setPosition:(CGPoint)position {
	[super setPosition:position];
	[self update_hit_rect];
}

-(void)i_update:(GameEngineScene*)g {
	if (!ccnode_is_visible(self)) return;
	[self update_hit_rect];
	
	float sprite_target_scale = _sprite_default_scale;
	
	if (hitrect_contains_point(_hitrect, g.get_control_manager.get_proc_tap)) {
		if (g.get_control_manager.is_proc_tap) {
			[g.get_control_manager clear_proc_tap];
			sprite_target_scale = _sprite_default_scale * 1.5;
			callback_run(_callback);
			
		} else if (g.get_control_manager.is_touch_down) {
			sprite_target_scale = _sprite_default_scale * 1.25;
			
		}
	}
	
	_sprite.scale = drpt(_sprite.scale, sprite_target_scale, 1/10.0);
	
}

@end
