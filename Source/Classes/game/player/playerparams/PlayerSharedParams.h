//
//  PlayerSharedParams.h
//  hanokam
//
//  Created by spotco on 06/06/2015.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PlayerSharedParams : NSObject

@property(readwrite,assign) CGPoint _s_pos;
@property(readwrite,assign) float _calc_accel_x_pos; //actual 1-to-1 x position (not offset by dashing)
@property(readwrite,assign) BOOL _reset_to_center;

@end
