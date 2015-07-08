//
//  UIEnemyNoticeParticle.h
//  hanokam
//
//  Created by spotco on 01/07/2015.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "Particle.h"
#import "GEventDispatcher.h"

@interface EnemyNoticeParticle : Particle <GEventListener>
+(EnemyNoticeParticle*)cons_pos:(CGPoint)pos g:(GameEngineScene *)g target:(id)target;
@end
