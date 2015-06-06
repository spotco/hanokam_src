//
//  FlashCount.m
//  hanokam
//
//  Created by spotco on 06/06/2015.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "FlashCount.h"

@implementation FlashCount {
	NSMutableArray *_counts;
	int _i;
}
+(FlashCount*)cons {
	return [[[FlashCount alloc] init] cons];
}
-(FlashCount*)cons {
	_counts = [NSMutableArray array];
	return self;
}
-(void)add_flash_at:(float)time {
	[_counts addObject:@(time)];
	[_counts sortUsingComparator:^NSComparisonResult(NSNumber *o1, NSNumber *o2) { return [o2 compare:o1]; }];
}
-(void)add_flash_at_times:(NSArray*)times {
	for (NSNumber *itr in times) {
		[_counts addObject:itr];
	}
	[_counts sortUsingComparator:^NSComparisonResult(NSNumber *o1, NSNumber *o2) { return [o2 compare:o1]; }];
}
-(void)reset {
	_i = 0;
}
-(BOOL)do_flash_given_time:(float)time {
	if (_i >= _counts.count) return NO;
	bool rtv = ((NSNumber*)_counts[_i]).floatValue >= time;
	if (rtv) _i++;
	return rtv;
}
@end
