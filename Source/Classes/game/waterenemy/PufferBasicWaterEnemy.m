//
//  PufferBasicWaterEnemy.m
//  hanokam
//
//  Created by spotco on 01/07/2015.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "PufferBasicWaterEnemy.h"
#import "PufferEnemySprite.h"

@implementation PufferBasicWaterEnemy {
	PufferEnemySprite *_img;
	
}

+(PufferBasicWaterEnemy*)cons_g:(GameEngineScene*)g pt1:(CGPoint)pt1 pt2:(CGPoint)pt2 {
	return [[PufferBasicWaterEnemy node] icons_g:g pt1:pt1 pt2:pt2];
}
-(PufferBasicWaterEnemy*)icons_g:(GameEngineScene*)g pt1:(CGPoint)pt1 pt2:(CGPoint)pt2 {
	[super cons_g:g pt1:pt1 pt2:pt2];
	
	_img = [PufferEnemySprite cons];
	[self addChild:_img];
	
	return self;
}

-(void)i_update:(GameEngineScene *)g {
	[super i_update:g];
	
	switch (self._current_mode) {
	case BasicWaterEnemyMode_IdleMove:{
		[_img update_playAnim:_img._anim_idle];
	}
	break;
	case BasicWaterEnemyMode_InPack:{
		[_img update_playAnim:_img._anim_follow];
	}
	default:break;
	}
}

-(HitRect)get_hit_rect { return [_img get_hit_rect_pos:self.position]; }
-(void)get_sat_poly:(SATPoly*)in_poly { return [_img get_sat_poly:in_poly pos:self.position rot:self.rotation]; }

@end
