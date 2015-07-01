//
//  DelayAction.h
//  hanokam
//
//  Created by Shiny Yang on 6/30/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DelayAction : NSObject
@property(readwrite,assign) float _time_left;
+(DelayAction*)cons_in:(float)time action:(void(^)())action;
@end

@interface DelayActionQueue : NSObject
+(DelayActionQueue*)cons;
-(void)i_update:(float)dt_scale;
-(void)enqueue_action:(DelayAction*)action;
@end
