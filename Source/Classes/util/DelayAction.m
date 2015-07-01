//
//  DelayAction.m
//  hanokam
//
//  Created by Shiny Yang on 6/30/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "DelayAction.h"

@implementation DelayAction {
    void (^_action)(void);
}
@synthesize _time_left;
+(DelayAction*)cons_in:(float)time action:(void(^)())action {
    return [[[DelayAction alloc] init] cons_in:time action:action];
}
-(DelayAction*)cons_in:(float)time action:(void(^)())action {
    self._time_left = time;
    _action = action;
    return self;
}
-(void)run_and_cleanup {
    _action();
    _action = NULL;
}

@end

@implementation DelayActionQueue {
    NSMutableArray *_queue;
    NSMutableArray *_to_remove;
}
+(DelayActionQueue*)cons{
    return [[[DelayActionQueue alloc] init] cons];
}
-(DelayActionQueue*)cons {
    _queue = [NSMutableArray array];
    _to_remove = [NSMutableArray array];
    return self;
}
-(void)i_update:(float)dt_scale{
    for (NSInteger i = _queue.count-1; i >= 0; i--) {
        DelayAction *itr = [_queue objectAtIndex:i];
        itr._time_left -= dt_scale;
        if (itr._time_left <= 0) {
            [itr run_and_cleanup];
            [_to_remove addObject:itr];
        }
    }
    [_queue removeObjectsInArray:_to_remove];
    [_to_remove removeAllObjects];
}
-(void)enqueue_action:(DelayAction*)action{
    [_queue addObject:action];
}
@end
