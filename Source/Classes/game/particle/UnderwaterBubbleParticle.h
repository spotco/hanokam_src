//
//  UnderwaterBubbleParticle.h
//  hanokam
//
//  Created by Shiny Yang on 6/30/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "Particle.h"

@interface UnderwaterBubbleParticle : Particle

+(UnderwaterBubbleParticle*)cons_start:(CGPoint)start end:(CGPoint)end;
-(UnderwaterBubbleParticle*)set_scale_start:(float)start end:(float)end;
-(UnderwaterBubbleParticle*)set_opacity_start:(float)start end:(float)end;
@end
