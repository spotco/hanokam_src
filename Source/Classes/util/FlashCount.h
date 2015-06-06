//
//  FlashCount.h
//  hanokam
//
//  Created by spotco on 06/06/2015.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FlashCount : NSObject
+(FlashCount*)cons;
-(void)add_flash_at:(float)time;
-(void)add_flash_at_times:(NSArray*)times;
-(void)reset;
-(BOOL)do_flash_given_time:(float)time;
@end
