//
//  Arrow.m
//  hobobob
//
//  Created by spotco on 22/03/2015.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "PlayerProjectile.h"
@implementation PlayerProjectile
-(HitRect)get_hit_rect { return hitrect_cons_xy_widhei(self.position.x, self.position.y, 1, 1); }
-(void)get_sat_poly:(SATPoly *)in_poly { SAT_cons_quad_buf(in_poly, CGPointZero, CGPointZero, CGPointZero, CGPointZero); }
-(BOOL)get_active { return YES; }
@end
