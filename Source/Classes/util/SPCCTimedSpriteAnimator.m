//
//  SPCCTimedSpriteAnimator.m
//  hanokam
//
//  Created by spotco on 14/07/2015.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "SPCCTimedSpriteAnimator.h"

@implementation SPCCTimedSpriteAnimator {
	NSMutableDictionary *_time_to_frames;
	NSMutableArray *_sorted_times;
	CCSprite *_tar;
	
}
+(SPCCTimedSpriteAnimator*)cons_target:(CCSprite*)tar {
	return [[[SPCCTimedSpriteAnimator alloc] init] cons_target:tar];
}
-(SPCCTimedSpriteAnimator*)cons_target:(CCSprite*)tar {
	_time_to_frames = [NSMutableDictionary dictionary];
	_sorted_times = [NSMutableArray array];
	_tar = tar;
	return self;
}
-(void)set_target:(CCSprite *)tar {
	_tar = tar;
}
-(void)add_frame:(CGRect)frame at_time:(float)time {
	_time_to_frames[@(time)] = [NSValue valueWithCGRect:frame];
	[_sorted_times addObject:@(time)];
	[_sorted_times sortUsingSelector:@selector(compare:)];
}

-(void)show_frame_for_time:(float)t {
	NSNumber *key = NULL;
	for (int i = 0; i < _sorted_times.count; i++) {
		NSNumber *itr = _sorted_times[i];
		if (key == NULL) key = itr;
		if (itr.floatValue <= t) {
			key = itr;
		} else {
			break;
		}
	}
	if (key == NULL) return;
	[_tar setTextureRect:((NSValue*)_time_to_frames[key]).CGRectValue];
}

@end
