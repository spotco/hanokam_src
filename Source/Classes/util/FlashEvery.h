//
//  FlashEvery.h
//  hanokam
//
//  Created by spotco on 07/06/2015.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FlashEvery : NSObject
+(FlashEvery*)cons_time:(float)time;
-(void)i_update:(float)time_scale;
-(BOOL)do_flash;
-(void)set_time:(float)time;
@end
