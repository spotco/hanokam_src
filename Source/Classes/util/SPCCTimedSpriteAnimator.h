//
//  SPCCTimedSpriteAnimator.h
//  hanokam
//
//  Created by spotco on 14/07/2015.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SPCCTimedSpriteAnimator : NSObject

+(SPCCTimedSpriteAnimator*)cons_target:(CCSprite*)tar;
-(void)set_target:(CCSprite*)tar;
-(void)add_frame:(CGRect)frame at_time:(float)time;
-(void)show_frame_for_time:(float)t;

@end
