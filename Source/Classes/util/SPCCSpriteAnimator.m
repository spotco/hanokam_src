//
//  SPCCSpriteAnimator.m
//  hanokam
//
//  Created by spotco on 07/06/2015.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "SPCCSpriteAnimator.h"

@implementation SPCCSpriteAnimator {
	NSMutableArray *_frames;
	CCSprite *_tar;
	float _speed, _ct;
	int _i;
}

+(SPCCSpriteAnimator*)cons_target:(CCSprite*)tar speed:(float)speed {
	return [[SPCCSpriteAnimator node] cons_target:tar speed:speed];
}
-(SPCCSpriteAnimator*)cons_target:(CCSprite*)tar speed:(float)speed {
	_frames = [NSMutableArray array];
	_tar = tar;
	_speed = speed;
	_i = 0;
	_ct = 0;
	return self;
}
-(SPCCSpriteAnimator*)add_frame:(CGRect)frame {
	[_frames addObject:[NSValue valueWithCGRect:frame]];
	return self;
}

-(void)update:(CCTime)delta {
	if (_frames.count==0) return;
	CGRect tar_rect = ((NSValue*)[_frames objectAtIndex:_i]).CGRectValue;
	
	if (!CGRectEqualToRect(tar_rect, _tar.textureRect)) {
		[_tar setTextureRect:tar_rect];
	}
	float dt_scale = clampf(delta/(1/60.0f), 0.25, 3);
	_ct -= dt_scale;
	
	while (_ct <= 0) {
		_ct = _speed+_ct;
		_i++;
		if (_i >= _frames.count) {
			_i = 0;
		}
	}

}

@end
