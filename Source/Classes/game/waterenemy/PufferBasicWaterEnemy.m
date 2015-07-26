//
//  PufferBasicWaterEnemy.m
//  hanokam
//
//  Created by spotco on 01/07/2015.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "PufferBasicWaterEnemy.h"
#import "PufferEnemySprite.h"
#import "FlashCount.h"

@implementation PufferBasicWaterEnemy {
	PufferEnemySprite *_img;
	ccColor4F _tar_color;
	FlashCount *_flashcount;
	
}

+(PufferBasicWaterEnemy*)cons_g:(GameEngineScene*)g pt1:(CGPoint)pt1 pt2:(CGPoint)pt2 {
	return [[PufferBasicWaterEnemy node] icons_g:g pt1:pt1 pt2:pt2];
}
-(PufferBasicWaterEnemy*)icons_g:(GameEngineScene*)g pt1:(CGPoint)pt1 pt2:(CGPoint)pt2 {
	[super cons_g:g pt1:pt1 pt2:pt2];
	
	_img = [PufferEnemySprite cons];
	[self addChild:_img];
	
	_tar_color = ccc4f(1.0, 1.0, 1.0, 1.0);
	_flashcount = [FlashCount cons];
	[_flashcount add_flash_at_times:@[@30,@20,@10]];
	
	return self;
}

-(void)i_update:(GameEngineScene *)g {
	[super i_update:g];
	
	switch (self._current_mode) {
	case BasicWaterEnemyMode_IdleMove:{
		[_img update_playAnim:_img._anim_idle];
	} break;
	case BasicWaterEnemyMode_InPack:{
		[_img update_playAnim:_img._anim_follow];
	} break;
	case BasicWaterEnemyMode_Stunned:{
		if ([_flashcount do_flash_given_time:[self get_stunned_anim_ct]]) {
			_tar_color.b = 0.0;
			_tar_color.g = 0.0;
		}
	} break;
	default:break;
	}
	
	[_img setColor4f:_tar_color];
	_tar_color.b = drpt(_tar_color.b, 1.0, 1/8.0);
	_tar_color.g = drpt(_tar_color.g, 1.0, 1/8.0);
}

-(HitRect)get_hit_rect { return [_img get_hit_rect_pos:self.position]; }
-(void)get_sat_poly:(SATPoly*)in_poly { return [_img get_sat_poly:in_poly pos:self.position rot:self.rotation]; }

@end
