//
//  SPCCSpriteAnimator.h
//  hanokam
//
//  Created by spotco on 07/06/2015.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "CCNode.h"

@interface SPCCSpriteAnimator : CCNode

+(SPCCSpriteAnimator*)cons_target:(CCSprite*)tar speed:(float)speed;
-(SPCCSpriteAnimator*)add_frame:(CGRect)frame;

@end
