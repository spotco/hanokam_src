//
//  FlashEvery.m
//  hanokam
//
//  Created by spotco on 07/06/2015.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "FlashEvery.h"

@implementation FlashEvery {
	float _max_time, _time;
}
+(FlashEvery*)cons_time:(float)time {
	return [[[FlashEvery alloc] init] cons_time:time];
}
-(FlashEvery*)cons_time:(float)time {
	_max_time = time;
	_time = 0;
	return self;
}
-(void)set_time:(float)time {
    _max_time = time;
}
-(void)i_update:(float)time_scale {
	_time -= time_scale;
}
-(BOOL)do_flash {
	BOOL rtv = _time <= 0;
	if (rtv) _time = _max_time;
	return rtv;
}
@end
