//
//  PufferEnemySprite.h
//  hanokam
//
//  Created by spotco on 01/07/2015.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "Common.h"
#import "PolyLib.h" 

@interface PufferEnemySprite : CCSprite_Animated
@property(readwrite,strong) CCAction *_anim_idle, *_anim_attack, *_anim_die, *_anim_follow, *_anim_hurt;
+(PufferEnemySprite*)cons;
-(HitRect)get_hit_rect_pos:(CGPoint)pos;
-(void)get_sat_poly:(SATPoly*)in_poly pos:(CGPoint)pos rot:(float)rot;
@end
